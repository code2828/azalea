#include<iostream>
#include<cstring>
#include<stdexcept>
#include<vector>

#define ERR_CHAR_TOO_LONG "Err: Multiple characters between \'\'."
#define ERR_CHAR_UNXP_EOF "Err: Unexpected EOF instead of an enclosing \'."
#define ERR_CHAR_UKN_ESC "Err: Unknown escape sequence."
#define ERR_STR_UNXP_EOF "Err: Unexpected EOF instead of an enclosing \"."
#define ERR_CMT_UNXP_EOF "Err: Unexpected EOF instead of an enclosing `."

using namespace std;

enum Token
{
	//                  ** BASIC MEMORY MANIPULATION **
	// ------------------------------------------------------------------------
	// '#': ALLOCATE
	//
	// #p `allocate memory the size of int and assign it to identifier p`
	// @p = 0 `OK, value of p is now 0`
	// p++ `OK for now`
	// @p = 1 `INVALID - runtime error, because this piece of memory does not
	//         belong to p`
	//
	// #q 3 `allocate memory 3 times the size of int and assign the first 4
	//       bytes to identifier q`
	// @q = 0 `OK`
	// q++
	// @q = 1 `OK`
	// q++
	// @q = 2 `OK`
	// q++
	// @q = 3 `INVALID - runtime error, same as above`
	//
	// #a b c d e `allocate five ints and assign respectively in one loc`
	TOK_ALLOC,

	// '$', FREE
	// 
	// #p
	// #p `ILLEGAL - redefinition of identifier p`
	// @p = 0
	// $p `frees the memory that used to be p for future use, also deregisters
	//     the identifier`
	// @p = 0 `ILLEGAL - unknown identifier`
	// #p @p = 0 `OK`
	//
	// #q 4
	// @q = 0
	// @(q+1) = 1
	// @(q+2) = 2
	// @(q+3) = 3
	// $q `if a block of memory was alloc-ed for q, it will be automatically
	//     deallocated`
	//
	// #r 3
	// @r = -1
	// r++
	// @r = -2
	// r++
	// @r = -3 `initializes an array: [-1,-2,-3], r pointing at -3`
	// $r `removes the original memory block allocated for r, which currently
	//     is r, r-1 and r-2`
	TOK_DEL,

	
	//                         ** STACK OPERATION **
	// ------------------------------------------------------------------------
	// ']', PUSH
	//
	// ] @a `push the value of a into stack`
	// 
	// ] a `push the address of a into stack`
	TOK_PUSH,

	// '[', POP
	//
	// [ a `pop the top of stack into a`
	// 
	// `[ @a` `INVALID, value of a pointer is rvalue`
	TOK_POP,


	//                        ** DATA MANIPULATION **
	// ------------------------------------------------------------------------
	// '@', AT
	//
	// @q `data in memory pointed by q`
	TOK_AT,

	// '=', ASSIGN
	//
	// @a = 3 `data in memory pointed by a is now 3`
	//
	// #r 4
	// @r = 0 @(r+1) = 1 @(r+2) = 2 @(r+3) = 3 `tl;didn't want to code`
	// @r = 0 1 2 3 `puts the four numbers in one statement`
	//
	// #s 5
	// @r = 'H' 'e' 'l' 'l' 'o'
	// @r = "Hello" `be lazy`
	TOK_ASN,


	//           ** ARITHMETIC, BITWISE AND LOGICAL OPERATIONS **
	// ------------------------------------------------------------------------
	// ** Notes on bitwise and logical operators and truthiness **
	// A boolean expression such as 1 == 2 produces a temporary int-sized
	// memory location storing the result (0, aka false, in this case). When
	// 0 and 1 are bitwisely and-ed, the result is consistent with the logical
	// version - both produce 0 in this example. So expressions like
	// 1 == 2 & 1 < 6 work well even if the operator is used bitwisely. As a
	// result, being loyal to the idea of a minimalist language, logical and
	// (&&), or (||) operators are omitted.
	//
	// Any value is considered truthy, except 0, which is considered falsey.
	// This definition of truthiness is the same as C and C-like languages, and
	// I (personally) believe that it is quite natural.
	//
	//
	// '+', ADD
	//
	// @a + 2 `value of a plus 2`
	//
	// a + 2 `2*32 bits forward of address of pointer a`
	TOK_ADD,

	// '-', SUBTRACT or NEGATE
	// 
	// * Have both unary version and binary version.
	//
	// @s - 3  `value of s minus 3`
	//
	// s - 2 `2*32 bits backward of address of pointer s`
	//
	// -5 => -5
	//
	// -(a-b) => b-a 
	TOK_SUB,

	// '*', MULTIPLY
	//
	// @m * 8 `value of m times 3`
	TOK_MULT,

	// '/', DIVIDE
	//
	// @d / 3 `value of d divided by 3, rounded towards 0 if not divisible`
	TOK_DIV,

	// '%', MODULUS
	//
	// @e % 6 `remainder of e divided by 6`

	// "++", INCREMENT
	//
	// @q ++ `value of q incremented by 1`
	//
	// q ++ `pointer q moves forward 32 bits`
	TOK_INC,

	// "--", DECREMENT
	//
	// @r -- `value of q decremented by 1`
	//
	// r -- `pointer q moves backward 32 bits`
	TOK_DEC,

	// '&', AND
	//
	// @a & @b `bitwise AND of the two operators`
	TOK_AND,

	// '|', OR
	//
	// @a | @b `bitwise OR of the two operators`
	TOK_OR,

	// '^', XOR
	//
	// @a ^ @b `bitwise XOR of the two operators`

	// '~', NOT (or one's complement)
	//
	// ~ @a `bitwise not of the operator`
	TOK_NOT,

	// '!', LOGICAL NOT
	//
	// ! @a `logical not of the operator`
	TOK_LNOT,

	//                           ** COMPARISON **
	// ------------------------------------------------------------------------
	// "==", EQUAL TO
	//
	// @a == 9 `true if value of a is equal to 9, false otherwise`
	//
	// a == b `a and b point to the same memory location`
	TOK_EQ,

	// '<', LESS THAN
	//
	// @a < 30 `true if value of a is less than 30, false otherwise`
	TOK_LT,

	// '>', GREATER THAN
	//
	// @a > 14 `true if value of a is greater than 14, false otherwise`
	TOK_GT,

	// '(' and ')', PARENTHESES, used to alter the order of calculation
	TOK_OPAR,
	TOK_CPAR,


	//                       ** PROGRAM STRUCTURE **
	// ------------------------------------------------------------------------
	// ':', LABEL
	//
	// :label `labels are most commonly used along with the jmp token '=>', see
	//         below for more information on that.`
	// 
	// :1 `numerical names can be used to indicate a temporary label. for an
	//     example using this, see below.`
	TOK_LBL,

	// "=>", JUMP
	//
	// #a
	// @a = 0
	// `loop blocks, although without any actual impact on compilation, are
	//  recommended to be indented by 1 tab.`
	// :loop
	//     @a ++
	//     << @a + '0' `output a`
	//     << '\n'
	//     `checks if @a is 100; if yes then break, else enter next loop.`
	//	   ? @a == 100 ,
	//	       =>1 `jumping to numbers lands you on the very next label with
	//	            the same number. This helps avoid using excessive labels
	//	            with meaningless names for break statements. These labels
	//	            can be considered temporary and can be reused, while labels
	//	            whose names are identifiers cannot be redefined and are
	//	            unique.`
	//	   ;
	//	       =>loop
	//	   .
	// :1
	TOK_JMP,

	// '\', RETURN, jumps to the next statement of the last invoked "=>"
	//              statement:
	//
	// :q
	//     @a++
	//     \
	// @a = 0
	// =>q
	// << @a + '0' `=> prints: 1`
	TOK_RET,

	
	//                          ** CONDITIONS **
	// ------------------------------------------------------------------------
	// '?', e.g.:
	//
	// `prints 3 if @a > 3, 0 if @a < 0, else itself`
	// ? @a > 3 ,
	//     << '3'
	// ;? @a < 0 , `literally else if statement`
	//     << '0'
	// ;
	//     << @a + '0'
	// .
	TOK_COND,

	// ','. see above.
	TOK_THEN,

	// ';'. see above
	TOK_ELSE,

	// ";?", see above
	//
	// Special token for elif statements to avoid the use of multiple '.' at
	// the end of a control statement.
	TOK_ELIF,

	// '.', indicates where a '?' statement ends, see above
	TOK_END,


	//                        ** INPUT / OUTPUT **
	// ------------------------------------------------------------------------
	// ">>", e.g.:
	//
	// `fetch the next character in input buffer and stores it in a`
	// >> a
	//
	// `>> @a` `illegal!!`
	TOK_IN,

	// "<<", e.g.:
	//
	// `attempt to output the parameter as a char`
	// << 'b' `=> prints: b`
	// << 9 `=>	prints: <tab>`
	// << '9' `=> prints: 9` 
	TOK_OUT,

	
	//                          ** IDENTIFIER **
	// ------------------------------------------------------------------------
	// An identifier. An identifier may only start with a letter or _, and may
	// contain A-Za-z0-9_ after that.
	// 
	// Valid identifiers:
	// AkzZ
	// A_________________
	// a694_931
	// an_1d3nt1f13r_w1th_a_v3ry_10ng_nam3_and_50me_num63r5
	//
	// Identifiers that start with '_' and followed by digits are reserved for
	// function calls. They can be used WITHOUT declaration or initiation. See
	// examples/fib.eyl as an example for more information on this.
	//
	// The special identifier @_ is also related to functions. It stores the
	// return value of a funtion when using the '\' (aka RET) operator with a
	// parameter.
	//
	// In general, '_'-beginning identifiers should be reserved for uses like
	// "function calls" (through JMP (->) operation) or immediately discarded
	// values.
	//
	// Invalid identifiers:
	// 08dd (identifiers cannot start with a digit)
	TOK_ID,

	
	//                        ** NUMERIC LITERAL **
	// ------------------------------------------------------------------------
	// A number. Might represent a char.
	// 42 => 42
	// 0h42 ≡ 0x42 => 66
	// 0o42 ≡ 042 => 34
	// 0b101010 => 42
	// '*' => 42
	// Note that character literals are just aliases for the corresponding
	// number, as in the last example.
	TOK_NUM
};

inline bool is_whitespace(char c)
{
	return ((c) == ' ' || (c) == '\t' || (c) == '\n' || (c) == '\r');
}

vector<Token> tokens;

//                            ** PREPROCESSING **
// ----------------------------------------------------------------------------
// As a really simple language, one could expect Eryuelan to have little need
// for preprocessing. As such, there are only four things that the preprocessor
// is meant to do (in order):
//
// 1. Remove comments.
// 2. Replace all string literals with a list of characters.
// 3. Replace all character literals with ints.
// 4. Checkwhite.
//
// Whitespaces, newlines and indentations are purely for readability and are
// needed only when necessary. Thus, the example of TOK_JMP can also be written
// as:
//
// #a
// @a = 0
// :loop
// @a ++
// << @a + '0' << '\n'
// ? @a == 100 , =>1 ; =>loop . :1
//
// Or even denser:
//
// #a@a=0:loop@a++<<@a+'0'<<'\n'?@a==100,=>1;=>loop.:1
void preprocess(string& s)
{
	for(int i = 0; i < s.length(); i++)
	{
		if(s[i] != '`')
			continue;
		s.erase(i, 1);
		if(i >= s.length())
			throw out_of_range(ERR_CMT_UNXP_EOF);
		while(s[i] != '`')
		{
			s.erase(i, 1);
			if(i >= s.length())
				throw out_of_range(ERR_CMT_UNXP_EOF);
		}
		s.erase(i, 1);
	}
	for(int i = 0; i < s.length(); i++)
	{
		if(s[i] != '\"')
			continue;
		if(i > 0)
			if(s[i - 1] == '\\')
			{
				i++;
				continue;
			}
		int j = i;
		string str = " ";
		i++;
		if(i >= s.length())
			throw out_of_range(ERR_STR_UNXP_EOF);
		while(s[i] != '\"')
		{
			if(s[i] == '\"') break;
			str.append(" \'");
			str.push_back(s[i]);
			if(s[i] == '\\') // escape char
			{
				if(i >= s.length() - 1)
					throw out_of_range(ERR_STR_UNXP_EOF);
				if(s[i + 1] == '\"')
				{
					str.append("\"\' ");
					i += 2;
					if(i >= s.length())
						throw out_of_range(ERR_STR_UNXP_EOF);
					continue;
				}
				else
					str.push_back(s[++i]);
			}
			str.append("\' ");
			i++;
			if(i >= s.length())
				throw out_of_range(ERR_STR_UNXP_EOF);
		}
		str.append(" ");
		s.erase(j, i - j + 1);
		s.insert(j, str);
		i = j - 1;
	}
	for(int i = 0; i < s.length(); i++)
	{
		int j = i;
		if(s[i] != '\'')
			continue;
		int t;
		if(i >= s.length() - 2)
			throw out_of_range(ERR_CHAR_UNXP_EOF);
		if(s[i + 1] == '\\') // escape chars
		{
			if(i >= s.length() - 3)
				throw out_of_range(ERR_CHAR_UNXP_EOF);
			if(s[i + 3] != '\'')
				throw out_of_range(ERR_CHAR_TOO_LONG);
			switch(s[i + 2])
			{
				case 'n': t = 10; break;
				case '\"': t = '\"'; break;
				case '\'': t = '\''; break;
				// TODO: handle escape chars
				default: throw range_error(ERR_CHAR_UKN_ESC);
			}
			i += 4;
		}
		else // not an escape char
		{
			if(s[i + 2] != '\'')
				throw out_of_range(ERR_CHAR_TOO_LONG);
			t = s[i + 1];
			i += 3;
		}
		string str = " ";
		str.append(to_string(t));
		str.push_back(' ');
		s.erase(j, i - j);
		s.insert(j, str);
		i = j - 1;
	}
	while(is_whitespace(s[0]) && !s.empty())
		s.erase(0, 1);
	for(int i = 0; i <= s.length(); i++)
	{
		if(!is_whitespace(s[i]))
			continue;
		while(is_whitespace(s[i]) && i < s.length())
			s.erase(i, 1);
		s.insert(i, " ");
	}
	while(is_whitespace(s[s.length() - 1]) && !s.empty())
		s.erase(s.length() - 1);
}

//                          ** TOKENIZATION **
// ----------------------------------------------------------------------------
// Tokenizes the code string into a list of tokens.
void tokenize(string s)
{
	cout << "Hello, World!\n";
}

//                             ** PARSE **
// ----------------------------------------------------------------------------
// Parses the list of tokens into statements, which have four types.
//
// ** A. Types of Statements **
//
// 1. Nullary Statement
// This type of statement only consists of a single operation token. RET opera-
// tions (\) are the only instances of this type of statement.
//
// 2. Unary Statement
//
// This type of statement consists of an operator token followed by one or more
// expression(s). Typically, this includes ALLOC operations (#), DEL operations
// ($), PUSH/POP operations (] and [), LBL operations (:), JMP operations (=>),
// and I/O operations (>> and <<).
//
// 3. Binary Statement
// 
// This type of statement consists of an expression followed by an operator to-
// ken and then followed by a group of one or more expression(s). ASN opera-
// tions (=) are the only instances of this type of statement.
//
// 4. Condition Statement
// This type of statement refers to the control statement that uses the tokens
// COND (?), THEN (,), ELSE (;), ELIF(;?) and END (.).
//
// ** B. Types of Expressions **
//
// 1. Constant
// A number constant, or a series of calculations that only consists of numbers
// and thus gives a predetermined number constant.
//
// 2. Calculation
// A series of calculations that contains stuff other than numbers. This in-
// cludes boolean expressions as they are represented by ints in Eryuelan.
//
// 3. Address
// An address.
//
// 4. Value
// An address following an AT (@) operator.
//
// Statements and expressions can be nested.
void parse()
{
	cout << "Hello, World!x2\n";
}

//                               ** RUNNING **
// ----------------------------------------------------------------------------
void run()
{
	cout << "Welcome to Eryuelan v0.1!\n";
	cout << "Copyright (c) 2025 Haocheng Zhang <stevenhaocheng@163.com>. ";
	cout << "All rights reserved.\n\n";
	cout << ">>> ";
}

int main() try
{
	string s = R"(`com"me'nt t"e'st`#a @a = "before\"after")";
	preprocess(s);
	cout << "Preprocessed:\n" << s << endl;
	tokenize(s);
	parse();
	run();
	cout << endl;

	return 0;
}
catch (const exception& e)
{
	cerr << e.what() << endl;
}
