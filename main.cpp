#include<iostream>
using namespace std;

// Whitespace, newline and indenting are purely for readability and are needed
// only when necessary. Thus, the example of TOK_JMP can also be written as:
//
// #a
// @a = 0
// :loop
// @a ++
// << @a + '0' << '\n'
// ? @a == 100 , ^1 ; ^loop . :1
//
// or even denser:
//
// #a@a=0:loop@a++<<@a+'0'<<'\n'?@a==100,^1;^loop.:1

enum Token
{
	// '#', e.g.:
	//
	// #p `allocate memory the size of int and assign it to identifier p`
	//
	// #q 3 `allocate memory 3 times the size of int and assign the first uint
	//       to identifier q.
	TOK_ALLOC,
	// '$', e.g.:
	// 
	// #p
	// @p = 0
	// $p `deallocates the memory that used to be p for future use, also de-
	//     registers the identifier`
	//
	// #p 4
	// @p = 0
	// @(p+1) = 1
	// @(p+2) = 2
	// @(p+3) = 3
	// $p `if a block of memory was alloc-ed for p, it will be automatically
	//     deallocated`
	TOK_DEL,
	// ']', e.g.:
	//
	// ] @a `push the value of a into stack`
	// 
	// ] a `push the address of a into stack`
	TOK_PUSH,
	// '[', e.g.:
	//
	// [ a `pop the top of stack into a`
	// 
	// `[ @a` `illegal!!`
	TOK_POP,
	// '+', e.g.:
	//
	// @a + 2 `data pointed by a plus 2`
	//
	// a + 2 `2*32 bits forward of address of pointer a`
	TOK_ADD,
	// '-', e.g.:
	//
	// @s - 3  `data pointed by s minus 3`
	//
	// s - 2 `2*32 bits backward of address of pointer s`
	TOK_SUB,
	// '*', e.g.:
	//
	// @m * 8 `data pointed by m times 3`
	TOK_MULT,
	// '/', e.g.:
	//
	// @d / 3 `data pointed d divided by 3, round to 0 if not divisible`
	TOK_DIV,
	// "++", e.g.:
	//
	// @q ++ `data pointed by q incremented by 1`
	//
	// q ++ `pointer q moves forward 32 bits`
	TOK_INC,
	// "--", e.g.:
	//
	// @r -- `data pointed by q decremented by 1`
	//
	// r -- `pointer q moves backward 32 bits`
	TOK_DEC,
	// '@', e.g.:
	//
	// @q `data in memory pointed by q`
	TOK_AT,
	// '=', e.g.:
	//
	// @a = 3 `data in memory pointed by a is now 3`
	TOK_ASSIGN,
	// "==", e.g.:
	//
	// @a == 9 `true if data pointed by a is equal to 9, false otherwise`
	TOK_EQ,
	// "!=", e.g.:
	//
	// @a != _7 `true if data pointed by a is not equal to negative 7, false
	//           otherwise`
	TOK_NEQ,
	// '<', e.g.:
	//
	// @a < 30 `true if data pointed by a is less than 30, false otherwise`
	TOK_LESS,
	// '>', e.g.:
	//
	// @a > 14 `true if data pointed by a is greater than 14, false otherwise`
	TOK_GREAT,
	// ** Notes on bitwise and logical operators and truthiness **
	// A boolean expression such as 1 == 2 produces a temporary int-sized
	// memory location storing the result (0, aka false, in this case). When
	// 0 and 1 are bitwisely and-ed, the result is consistent with the logical
	// version - both produce 0 in this example. So expressions like
	// 1 == 2 & 1 < 6 work well even if the operator is used bitwisely. As a
	// result, being loyal to the idea of a minimalist language, logical and
	// (&&), or (||) and not (!) operators are omitted.
	//
	// Any value is considered truthy, except 0, which is considered falsey.
	// This definition of truthiness is the same as C and C-like languages, and
	// I (personally) believe that it is quite natural.
	//
	// '&', e.g.:
	//
	// @a & @b `bitwise AND of a and b`
	TOK_AND,
	// '|', e.g.:
	//
	// @a | @b `bitwise OR of a and b`
	TOK_OR,
	// '~', e.g.:
	//
	// ~ @a `bitwise not of a`
	TOK_NOT,
	// ':', e.g.:
	//
	// :label `labels demand their own line, and they are mostly used along
	//         with the jmp token '^', see below for more information on that.`
	// 
	// :1 `numerical names can be used to indicate a temporary label. for an
	//     example using this, see below.`
	TOK_LBL,
	// '^', e.g.:
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
	//	       ^1 `jumping to numbers lands you on the very next label with the
	//	           same number. This helps avoid using excessive labels with
	//	           meaningless names for break statements. These labels can be
	//	           considered temporary and can be reused.
	//	   ;
	//	       ^loop
	//	   .
	// :1
	//	       
	TOK_JMP,
	// '?', e.g.:
	//
	// `prints 3 if @a > 3, 0 is @a < 0, else itself`
	// ? @a > 3 ,
	//     << '3'
	// ;? @a < 0 , `literally else if statement`
	//     << '0'
	// ;
	//     << @a + '0'
	// ..
	TOK_RET
	// '\', returns tho the next line of the last invoked ^ statement. e.g.:
	//
	// :q
	//     @a++
	//     \
	// @a = 0
	// ^q
	// << @a `=> prints: 1`
	TOK_COND,
	// ','. see above.
	TOK_THEN,
	// ';'. see above
	TOK_ELSE,
	// '.', indicates where a '?' statement ends, see above
	TOK_END,
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
	// An identifier. An identifier may only start with a letter, and may
	// contain A-Za-z0-9_ after that.
	// 
	// Valid identifiers:
	// AkzZ
	// A_________________
	// a694_931
	// an_1d3nt1f13r_w1th_a_v3ry_10ng_nam3_and_s0me_numb3rs
	//
	// Invalid identifiers:
	// _k (tokens starting with _ indicates a negative number, such as _5)
	// 08dd (identifiers cannot start with a digit)
	TOK_ID,
	// A number.
	// 42 => 42
	// _42 => -42
	// 0h42 ≡ 0x42 => 66
	// 0o42 ≡ 042 => 34
	// '*' => 42
	// Note that character literals are just aliases for the corresponding
	// number, as in the last example.
	TOK_NUM
}

int main()
{
	return 0;
}
