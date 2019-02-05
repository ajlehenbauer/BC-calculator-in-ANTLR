grammar grammer;

@header {
import java.util.*;
}

@members {
/** Map variable name to Integer object holding value */
HashMap memory = new HashMap();
}


//PARSER RULES
exprList: (topExpr|varDef) ( ';' (topExpr|varDef))* ';'? ; 

varDef: 
VAR ID '=' expr
{
    memory.put($ID.text, new Double($expr.i));
};

topExpr: (
    expr
    { System.out.println("result: "+ Double.toString($expr.i));}
    | boolExpr
    { System.out.println("result: "+ $boolExpr.b);}
    | compExpr
    { System.out.println("result: "+ $compExpr.b);}
    | 
   )
;

expr returns [double i]: 
     el=atom op='^' er=atom { $i=Math.pow($el.i,$er.i); }
    | 'e(' er=atom ')' { $i=Math.pow(Math.E,$er.i); }
    | 's(' er=atom ')' { $i=Math.sin($er.i); }
    | 'c(' er=atom ')' { $i=Math.cos($er.i); }
    | 'l(' er=atom ')' { $i=Math.log($er.i); }
    | 'sqrt(' er=atom ')' { $i=Math.sqrt($er.i); }
    | el=atom op='*' er=atom { $i=$el.i*$er.i; }
    | el=atom op='/' er=atom { $i=$el.i/$er.i; }
    | el=atom op='+' er=atom { $i=$el.i+$er.i; }
    | el=atom op='-' er=atom { $i=$el.i-$er.i; }
    | el=atom {$i=$el.i;}
   
    ;
    atom returns [double i]:
        INT {$i = Double.parseDouble($INT.text);}
    |   DOUBLE {$i = Double.parseDouble($DOUBLE.text);}
    |   ID
        {
        Double v = (double)memory.get($ID.text);
        if ( v!=null ) $i = v.doubleValue();
        else System.err.println("undefined variable "+$ID.text);
        }
    |   '(' expr ')' {$i = $expr.i;}
    ;
compExpr returns [int b]:
    
      el=atom op='>' er =atom { if($el.i>$er.i)$b=1; else $b=0; }
    | el=atom op='<' er =atom { if($el.i<$er.i)$b=1; else $b=0; }
    | el=atom op='==' er =atom { if($el.i==$er.i) $b=1; else $b=0; }
    
    ;
boolExpr returns [int b]:
    el = compExpr op='&&' er = compExpr{if( $el.b ==1 && $er.b==1)$b=1; else $b=0; }
    | el = compExpr op='||' er = compExpr{if( $el.b ==1|| $er.b==1)$b=1; else $b=0; }
    ;


//LEXAR RULES
VAR: 'var';  // keyword
COMMENT:('/*'~( '\r' | '\n' )*'*/') -> skip;
ID: [_A-Za-z]+;
INT: [0-9]+;
DOUBLE:('-'?)[0-9]+(('.'[0-9]+)?);
WS : [ \t\r\n]+ -> skip ;