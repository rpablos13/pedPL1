package compiler.lexical;

import compiler.syntax.sym;
import compiler.lexical.Token;
import es.uned.lsi.compiler.lexical.ScannerIF;
import es.uned.lsi.compiler.lexical.LexicalError;
import es.uned.lsi.compiler.lexical.LexicalErrorManager;

// incluir aqui, si es necesario otras importaciones

%%
 
%public
%class Scanner
%char
%line
%column
%cup


%implements ScannerIF
%scanerror LexicalError

// incluir aqui, si es necesario otras directivas

%{
    LexicalErrorManager lexicalErrorManager = new LexicalErrorManager ();
    private int commentCount = 0;
    private int linecom=0;
    private int columncom=0;
    private int contadorstring=0;
      
    
    //Función para crear los Tokens
    Token createToken (int x)  {
       Token token = new Token (x);
          token.setLine (yyline + 1);
          token.setColumn (yycolumn + 1);
          token.setLexema (yytext ());
          return token;}  
    
    
    //Función para crear un Error
    LexicalError createError(String mensaje){
      LexicalError error = new LexicalError (mensaje);
      error.setLine (yyline + 1);
      error.setColumn (yycolumn + 1);
      error.setLexema (yytext ());
      lexicalErrorManager.lexicalError (mensaje);
       return error;

    }
%}


ESPACIO_BLANCO=[ \t\r\n\f]
fin = "fin"{ESPACIO_BLANCO}
NUM= (0 | [1-9][0-9]*)
STRING = \".*\"
IDEN=[A-Za-z] ([A-Za-z] | [0-9])*


%x COMMENT

%%

<YYINITIAL> 
{
                       //delimitadores
    "\""                { return createToken(sym.COMILLAS); }
    "("                { return createToken(sym.OPEN_PAR); }
    ")"                { return createToken(sym.CLOSE_PAR); }
    "["                { return createToken(sym.OPEN_CORCH); }
    "]"                { return createToken(sym.CLOSE_CORCH); }
    "(*"                { commentCount++; yybegin(COMMENT);}
    "*)"               {lexicalErrorManager.lexicalError(createError("Error Lexico. No existe apertura en la Línea: "+(yyline + 1)));}
    ","                { return createToken(sym.COMMA); }
    ";"                { return createToken(sym.PUNTO_COMA); }
    ":="                { return createToken(sym.ASIGN); }
    ":"                { return createToken(sym.DOS_PUNTOS); }
    "*"                { return createToken(sym.MULT); }
    "-"                { return createToken(sym.MINUS); }
    ">"                { return createToken(sym.MAYOR); }
    "="                { return createToken(sym.EQUAL); }
    "."                { return createToken(sym.DOT); }
    
    "ARRAY"      {return createToken (sym.ARRAY);}
    "BEGIN"      {return createToken (sym.BEGIN);}
    "BOOLEAN"      {return createToken (sym.BOOLEAN);}
    "CONST"      {return createToken (sym.CONST);}
    "DO"      {return createToken (sym.DO);}
    "ELSE"      {return createToken (sym.ELSE);}
    "END"      {return createToken (sym.END);}
    "FALSE"      {return createToken (sym.FALSE);}
    "FOR"      {return createToken (sym.FOR);}
    "IF"      {return createToken (sym.IF);}
    "INTEGER"      {return createToken (sym.INTEGER);}
    "MODULE"      {return createToken (sym.MODULE);}
    "NOT"      {return createToken (sym.NOT);}
    "OF"      {return createToken (sym.OF);}
    "OR"      {return createToken (sym.OR);}
    "PROCEDURE"      {return createToken (sym.PROCEDURE);}
    "RETURN"      {return createToken (sym.RETURN);}
    "THEN"      {return createToken (sym.THEN);}
    "TO"      {return createToken (sym.TO);}
    "TRUE"      {return createToken (sym.TRUE);}
    "TYPE"      {return createToken (sym.TYPE);}
    "VAR"      {return createToken (sym.VAR);}
    "WRITEINT"      {return createToken (sym.WRITEINT);}
    "WRITELN"      {return createToken (sym.WRITELN);}
    "WRITESTRING"      {return createToken (sym.WRITESTRING);}
    

   {ESPACIO_BLANCO} {}
   
   //Expresiones
   
{fin} {}
{NUM} {return createToken (sym.NUM);}
{STRING}  {return createToken (sym.STRING);}
{IDEN}  {return createToken (sym.IDEN);}
    
    // error en caso de coincidir con ningún patrón
  [^]     
                        {                                               
                           LexicalError error = new LexicalError ();
                           error.setLine (yyline + 1);
                           error.setColumn (yycolumn + 1);
                           error.setLexema (yytext ());
                           lexicalErrorManager.lexicalError (error);
                        }
    
}
<COMMENT>{
  "(*" {commentCount++;}
  "*)" {commentCount--;
    if(commentCount == 0) yybegin(YYINITIAL);
  }
  .|{ESPACIO_BLANCO} {}
  
}
