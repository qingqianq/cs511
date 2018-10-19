-module(interp).
-export([scanAndParse/1,runFile/1,runStr/1]).
-include("types.hrl").

loop(InFile,Acc) ->
    case io:request(InFile,{get_until,prompt,lexer,token,[1]}) of
        {ok,Token,_EndLine} ->
            loop(InFile,Acc ++ [Token]);
        {error,token} ->
            exit(scanning_error);
        {eof,_} ->
            Acc
    end.

scanAndParse(FileName) ->
    {ok, InFile} = file:open(FileName, [read]),
    Acc = loop(InFile,[]),
    file:close(InFile),
    {Result, AST} = parser:parse(Acc),
    case Result of 
	ok -> AST;
	_ -> io:format("Parse error~n")
    end.


-spec runFile(string()) -> valType().
runFile(FileName) ->
    valueOf(scanAndParse(FileName),env:new()).

scanAndParseString(String) ->
    {_ResultL, TKs, _L} = lexer:string(String),
    parser:parse(TKs).

-spec runStr(string()) -> valType().
runStr(String) ->
    {Result, AST} = scanAndParseString(String),
    case Result  of 
    	ok -> valueOf(AST,env:new());
    	_ -> io:format("Parse error~n")
    end.


-spec numVal2Num(numValType()) -> integer().
numVal2Num({num, N}) ->
    N.

-spec boolVal2Bool(boolValType()) -> boolean().
boolVal2Bool({bool, B}) ->
    B.

-spec valueOf(expType(),envType()) -> valType().
valueOf(Exp,Env) ->
% Exp.
% [{letExp,{id,1,x},
%         {numExp,{num,1,1}},
%          {letExp,{id,1,x},
%                  {numExp,{num,1,3}},
%                  {plusExp,{idExp,{id,1,x}},{numExp,{num,1,7}}}}},
%  {plusExp,{numExp,{num,1,2}},{numExp,{num,1,3}}},
%  {procExp,{id,1,x},
%           {plusExp,{idExp,{id,1,x}},{numExp,{num,1,3}}}},
%  {letExp,{id,1,y},
%          {numExp,{num,1,3}},
%          {procExp,{id,1,x},
%                   {plusExp,{idExp,{id,1,x}},{idExp,{id,1,y}}}}},
%  {letExp,{id,1,y},
%          {numExp,{num,1,3}},
%          {plusExp,{numExp,{num,1,2}},{idExp,{id,1,y}}}},
%  {letExp,{id,1,y},
%          {procExp,{id,1,x},
%                   {plusExp,{idExp,{id,1,x}},{numExp,{num,1,1}}}},
%          {appExp,{idExp,{id,1,y}},{numExp,{num,1,5}}}},
%  "let x=1 in let y=proc(z) +(z,x) in y(6)"
%  {letExp,{id,1,x},
%          {numExp,{num,1,1}},
%          {letExp,{id,1,y},
%                  {procExp,{id,1,z},
%                           {plusExp,{idExp,{id,1,z}},{idExp,{id,1,x}}}},
%                  {appExp,{idExp,{id,1,y}},{numExp,{num,1,6}}}}},
%  {isZeroExp,{numExp,{num,1,7}}},
%  {letExp,{id,1,x},
%          {numExp,{num,1,1}},
%          {letExp,{id,1,f},
%                  {procExp,{id,1,y},
%                           {plusExp,{idExp,{id,1,y}},{idExp,{id,1,x}}}},
%                  {letExp,{id,1,x},
%                          {numExp,{num,1,2}},
%                          {appExp,{idExp,{id,1,f}},{numExp,{num,1,3}}}}}}]
%  "let x=1 in let f=proc (y) +(y,x) in let x=2 in f(3) ".


% expression -> num : {numExp, '$1'}.
% expression -> id : {idExp, '$1'}.
% expression -> minus oParen expression comma expression cParen : {diffExp, '$3', '$5'}.
% expression -> plus oParen expression comma expression cParen : {plusExp, '$3', '$5'}.
% expression -> 'isZero' oParen expression cParen  : {isZeroExp, '$3'}.

% expression -> 'if' expression 'then' expression 'else' expression  : 
%               {ifThenElseExp, '$2', '$4', '$6'}.

% expression -> 'let' id equals expression 'in' expression  : 
%               {letExp, '$2', '$4', '$6'}.
% expression -> 'proc' oParen id cParen expression : 
%             {procExp, '$3', '$5'}.

% expression -> expression oParen expression cParen : 
%             {appExp, '$1', '$3'}.

   case Exp of 
        {num,N} -> {num,N};
        {bool,B} ->{bool,B};
        {numExp,{num,_,N}} -> {num,N};
        {idExp,{id,_,Id}} -> env:lookup(Env,Id);
        {diffExp,Exp1,Exp2} -> 
            Temp = numVal2Num(valueOf(Exp1,Env)) - numVal2Num(valueOf(Exp2,Env)),
            {num,Temp};
        {plusExp,Exp1,Exp2} -> 
            Temp = numVal2Num(valueOf(Exp1,Env)) + numVal2Num(valueOf(Exp2,Env)),
            {num,Temp};
        {isZeroExp,ZeroExp} -> 
            Bool = {num,0} =:= valueOf(ZeroExp,Env),
            {bool,Bool};
        {ifThenElseExp,IfExp,ThenExp,ElseExp} ->
            IfCondition = boolVal2Bool(IfExp),
            if 
                true == IfCondition -> valueOf(ThenExp,Env);
                true ->  valueOf(ElseExp,Env)
            end;
        {letExp,IdE, SrcExp, DesExp} -> 
            {id,_,Id} = IdE,
            Temp = valueOf(SrcExp,Env),
            NewEnv = env:add(Env,Id,Temp),
            valueOf(DesExp,NewEnv);
        
%       a function f(z) and its Exp
        %{procExp,IdE,ExecuteExp} ->       use IdE confliction
            {procExp,IdE2,ExecuteExp} ->
            {id,_,Id} = IdE2,
            {procExp,Id,ExecuteExp,Env};
        
%          use "let x=1 in let y=proc(z) +(z,x) in y(6)".  example
%          {letExp,{id,1,x},                  
%          {numExp,{num,1,1}},
%          {letExp,{id,1,y},                %% store ProExp in y
%                  {procExp,{id,1,z},
%                           {plusExp,{idExp,{id,1,z}},{idExp,{id,1,x}}}},   Exp a
%                  {appExp,{idExp,{id,1,y}},{numExp,{num,1,6}}}}},          Exp b

%           make y = 6 in proc(z) -> +(z,x)
        {appExp,AppId,SrcExp} ->                  
            %before proExp, it should be a let then store it in dict, return proExp use AppId -> ProId
            {_, ProId, ProExp,ProEnv} = valueOf(AppId,Env), %ProId = z  
            SrcVal = valueOf(SrcExp,Env),       % y = 6  return z = 6 
            valueOf({letExp,{id,1,ProId},SrcVal,ProExp},ProEnv)      % y(6) = +(6,x) calculate letExp  Expb -> Expa                                                                           
        end.








