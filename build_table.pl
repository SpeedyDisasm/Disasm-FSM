use 5.016;
#use warnings;
#use diagnostics;
use constant DEFAULT_SIGNAL => 16;
use constant BYTE => 256;
use constant MAX_STATE => 163;

my @state; 
my @signal;
open my $outputState, ">", "state_table.dat" or die "wtf";
open my $outputSignal, ">", "signal_table.dat" or die "wtf";

#modRM 32
my @modrm_0 = (0x00..0x03, 0x08..0x0b, 0x10..0x13, 0x18..0x1b, 0x20..0x23, 0x28..0x2b, 0x30..0x33, 0x38..0x3b,
							0x06, 0x07, 0x0e, 0x0f, 0x16, 0x17, 0x1e, 0x1f, 0x26, 0x27, 0x2e, 0x2f, 0x36, 0x37, 0x3e, 0x3f, 
							0xc0..0xff);
my @modrm_1 = (0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x34, 0x3c, 
							0x40..0x43, 0x48..0x4b, 0x50..0x53, 0x58..0x5b, 0x60..0x63, 0x68..0x6b, 0x70..0x73, 0x78..0x7b,
							0x46, 0x47, 0x4e, 0x4f, 0x56, 0x57, 0x5e, 0x5f, 0x66, 0x67, 0x6e, 0x6f, 0x76, 0x77, 0x7e, 0x7f,
							0x45, 0x4d, 0x55, 0x5d, 0x65, 0x6d, 0x75, 0x7d);
my @modrm_2 = (0x44, 0x4c, 0x54, 0x5c, 0x64, 0x6c, 0x74, 0x7c);
my @modrm_4 = (0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x35, 0x3d,
							0x80..0x83, 0x88..0x8b, 0x90..0x93, 0x98..0x9b, 0xa0..0xa3, 0xa8..0xab, 0xb0..0xb3, 0xb8..0xbb,
							0x86, 0x87, 0x8e, 0x8f, 0x96, 0x97, 0x9e, 0x9f, 0xa6, 0xa7, 0xae, 0xaf, 0xb6, 0xb7, 0xbe, 0xbf,
							0x85, 0x8d, 0x95, 0x9d, 0xa5, 0xad, 0xb5, 0xbd);
my @modrm_5 = (0x84, 0x8c, 0x94, 0x9c, 0xa4, 0xac, 0xb4, 0xbc);
#modRM 16
my @modrm_16_0 = (0x00..0x03, 0x08..0x0b, 0x10..0x13, 0x18..0x1b, 0x20..0x23, 0x28..0x2b, 0x30..0x33, 0x38..0x3b,
								0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x34, 0x3c, 
								0x06, 0x07, 0x0e, 0x0f, 0x16, 0x17, 0x1e, 0x1f, 0x26, 0x27, 0x2e, 0x2f, 0x36, 0x37, 0x3e, 0x3f, 
								0xc0..0xff);
my @modrm_16_1 = (0x40..0x43, 0x48..0x4b, 0x50..0x53, 0x58..0x5b, 0x60..0x63, 0x68..0x6b, 0x70..0x73, 0x78..0x7b,
								0x44, 0x4c, 0x54, 0x5c, 0x64, 0x6c, 0x74, 0x7c,
								0x46, 0x47, 0x4e, 0x4f, 0x56, 0x57, 0x5e, 0x5f, 0x66, 0x67, 0x6e, 0x6f, 0x76, 0x77, 0x7e, 0x7f,
								0x45, 0x4d, 0x55, 0x5d, 0x65, 0x6d, 0x75, 0x7d);
my @modrm_16_2 = (0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x35, 0x3d,
								0x80..0x83, 0x88..0x8b, 0x90..0x93, 0x98..0x9b, 0xa0..0xa3, 0xa8..0xab, 0xb0..0xb3, 0xb8..0xbb,
								0x84, 0x8c, 0x94, 0x9c, 0xa4, 0xac, 0xb4, 0xbc,
								0x86, 0x87, 0x8e, 0x8f, 0x96, 0x97, 0x9e, 0x9f, 0xa6, 0xa7, 0xae, 0xaf, 0xb6, 0xb7, 0xbe, 0xbf,
								0x85, 0x8d, 0x95, 0x9d, 0xa5, 0xad, 0xb5, 0xbd);
#D9
{								
	my @d9_1 = (0x00..0x07, 0x40..0x47, 0x80..0x87, 0xc0..0xc7,
						0x10..0x17, 0x50..0x57, 0x90..0x97, 0xd0..0xd7,
						0x18..0x1f, 0x58..0x5f, 0x98..0x9f, 0xd8..0xdf);
	my @d9_2 = (0x28..0x2f, 0x68..0x6f, 0xa8..0xaf, 0xe8..0xef,
						0x38..0x3f, 0x78..0x7f, 0xb8..0xbf, 0xf8..0xff);
	my @d9_3 = (0x20..0x27, 0x60..0x67, 0xa0..0xa7, 0xe0..0xe7,
						0x30..0x37, 0x70..0x77, 0xb0..0xb7, 0xf0..0xf7);
	my @d9_4 = (0xc0..0xcf, 0xd0, 0xe0, 0xe1, 0xe4, 0xe5, 0xe8..0xee, 0xf0..0xff);
}
#DB
{
	my @db_1 = (0x00..0x1f, 0x40..0x5f, 0x80..0x9f, 0xc0..0xdf);
	my @db_2 = (0x28..0x2f, 0x68..0x6f, 0xa8..0xaf, 0xe8..0xef,
						0x38..0x3f, 0x78..0x7f, 0xb8..0xbf, 0xf8..0xff);
	my @db_3 = (0xc0..0xdf, 0xe2, 0xe3, 0xe8..0xef, 0xf0..0xf7);
}
#DD
{
	my @dd_1 = (0x00..0x1f, 0x40..0x5f, 0x80..0x9f, 0xc0..0xdf);
	my @dd_2 = (0x20..0x27, 0x60..0x67, 0xa0..0xa7, 0xe0..0xe7,
						0x30..0x37, 0x70..0x77, 0xb0..0xb7, 0xf0..0xf7);
	my @dd_3 = (0x38..0x3f, 0x78..0x7f, 0xb8..0xbf, 0xf8..0xff);
	my @dd_4 = (0xc0..0xc7, 0xd0..0xdf, 0xe0..0xef);
}
#DF
{
	my @df_1 = (0x00..0x1f, 0x40..0x5f, 0x80..0x9f, 0xc0..0xdf);
	my @df_2 = (0x28..0x2f, 0x68..0x6f, 0xa8..0xaf, 0xe8..0xef,
						0x38..0x3f, 0x78..0x7f, 0xb8..0xbf, 0xf8..0xff);
	my @df_3 = (0x20..0x27, 0x60..0x67, 0xa0..0xa7, 0xe0..0xe7,
						0x30..0x37, 0x70..0x77, 0xb0..0xb7, 0xf0..0xf7);
	my @df_4 = (0xe0, 0xe8..0xef, 0xf0..0xf7);
}


for(0..0xff*MAX_STATE) {
	$state[$_] = 0;
	$signal[$_] = DEFAULT_SIGNAL;
}
#A
{
	my @a1 = (0x00..0x03, 0x10..0x13, 0x20..0x23, 0x30..0x33, 0x62, 0x63, 0x84..0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08..0x0b, 0x18..0x1b, 0x28..0x2b, 0x38..0x3b, 0x88..0x8f, 0xfe, 0xff);
	my @a2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @a3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3,
					 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @a4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5, 
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @a5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @aa1 = (0x00, 0x02, 0x03, 0x10..0x17, 0x20..0x23, 0x40..0x47, 0x50..0x57, 0x60..0x67, 0x74, 0x75, 0x76,
						0x20..0x2f, 0x48..0x4f, 0x58..0x5f, 0x68..0x6b, 0x6e, 0x6f, 0x78, 0x79, 0x7e, 0x7f,
						0x90..0x97, 0xa3, 0xa5, 0xb0..0xb7, 0xc0, 0xc1, 0xc3, 0xc7, 0xd1..0xd5, 0xd7, 0xe0..0xe5, 0xe7, 0xf1..0xf7,
						0x98..0x9f, 0xab, 0xad, 0xaf, 0xbb..0xbf, 0xd8..0xdf, 0xe8..0xef, 0xf8..0xfe);
	my @aa2 = (0x05, 0x06, 0x07, 0x30..0x35, 0x37, 0x77,
						0x08, 0x09, 0x0d, 0x1f,
						0xa0..0xa2,
						0xa8..0xaa, 0xae, 0xc8..0xcf);
	my @aa3 = (0x70..0x73, 
						0xc2, 
						0xac, 0xba);
	my @aaa1 = (0x00..0x07, 0xf0, 0xf1,
						0x08..0x0b, 0x1c..0x1e);
	#15 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 15)] = 0;
		$signal[0x9a + (BYTE * 15)] = 6;
		$state[0xea + (BYTE * 15)] = 0;
		$signal[0xea + (BYTE * 15)] = 6;
		$state[0xc8 + (BYTE * 15)] = 0;
		$signal[0xc8 + (BYTE * 15)] = 3;
		$state[0xc2 + (BYTE * 15)] = 0;
		$signal[0xc2 + (BYTE * 15)] = 2;
		$state[0xca + (BYTE * 15)] = 0;
		$signal[0xca + (BYTE * 15)] = 2;
		foreach(@a4) {
			$state[$_ + (BYTE * 15)] = 0;
			$signal[$_ + (BYTE * 15)] = 0;
		}
		foreach(@a3) {
			$state[$_ + (BYTE * 15)] = 0;
			$signal[$_ + (BYTE * 15)] = 4;
		}
		foreach(@a2) {
			$state[$_ + (BYTE * 15)] = 0;
			$signal[$_ + (BYTE * 15)] = 1;
		}
		foreach(@a1) {
			$state[$_ + (BYTE * 15)] = 512 * 16;
			$signal[$_ + (BYTE * 15)] = DEFAULT_SIGNAL;
		}
		foreach(@a5) {
			$state[$_ + (BYTE * 15)] =512 * 17;
			$signal[$_ + (BYTE * 15)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 15)] =512 * 18;
		$signal[0xc7 + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 15)] =512 * 18;
		$signal[0x81 + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 15)] =512 * 18;
		$signal[0x69 + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 15)] =512 * 19;
		$signal[0xf0 + (BYTE * 15)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 15)] =512 * 148;
		$signal[0xd8 + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 15)] =512 * 149;
		$signal[0xd9 + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 15)] =512 * 150;
		$signal[0xda + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 15)] =512 * 151;
		$signal[0xdb + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 15)] =512 * 152;
		$signal[0xdc + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 15)] =512 * 153;
		$signal[0xdd + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 15)] =512 * 154;
		$signal[0xde + (BYTE * 15)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 15)] =512 * 155;
		$signal[0xdf + (BYTE * 15)] = DEFAULT_SIGNAL;
	}
	
	#16 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 16)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 16)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 16)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 16)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 16)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 16)] = 5;
		}
	}
	
	#17 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 17)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 17)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 17)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 17)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 17)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 17)] = 6;
		}
	}
	
	#18 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 18)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 18)] = 4;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 18)] = 5;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 18)] = 6;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 18)] = 8;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 18)] = 9;
		}
	}
	
	#19 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (BYTE * 19)] = 0;
			$signal[$_ + (BYTE * 19)] = 4;
		}
		foreach(@aa2) {
			$state[$_ + (BYTE * 19)] = 0;
			$signal[$_ + (BYTE * 19)] = 0;
		}
		foreach(@aa1) {
			$state[$_ + (BYTE * 19)] = 512 * 20;
			$signal[$_ + (BYTE * 19)] = DEFAULT_SIGNAL;
		}
		foreach(@aa3) {
			$state[$_ + (BYTE * 19)] =512 *  21;
			$signal[$_ + (BYTE * 19)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 19)] =512 *  22;
		$signal[0x38 + (BYTE * 19)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 19)] =512 *  23;
		$signal[0x3a + (BYTE * 19)] = DEFAULT_SIGNAL;
	}
	
	#20 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 20)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 20)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 20)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 20)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 20)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 20)] = 5;
		}
	}
	
	#21 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 21)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 21)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 21)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 21)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 21)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 21)] = 6;
		}
	}
	
	#22 состояние 3х-байтные опкоды 38
	{
		foreach(@aaa1) {
			$state[$_ + (BYTE * 22)] = 512 * 24;
			$signal[$_ + (BYTE * 22)] = DEFAULT_SIGNAL;
		}
	}
	
	#23 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 23)] = 512 * 25;
		$signal[0x0f + (BYTE * 23)] = DEFAULT_SIGNAL;
	}
	
	#24 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 24)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 24)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 24)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 24)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 24)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 24)] = 5;
		}
	}
	
	#25 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 25)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 25)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 25)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 25)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 25)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 25)] = 6;
		}
	}
	
	#148 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 148)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 148)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 148)] = 0;
		}
	}
	
	#149 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 149)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 149)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 149)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 149)] = 28;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 149)] = 0;
		}
	}
	
	#150 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 150)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 150)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 150)] = 0;
		}
		$signal[0xe1+ (BYTE * 150)] = 0;
	}
	
	#151 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 151)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 151)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 151)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 151)] = 0;
		}
	}
	
	#152 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 152)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 152)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 152)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 152)] = 0;
		}
	}
	
	#153 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 153)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 153)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 153)] = 108;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 153)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 153)] = 0;
		}
	}
	
	#154 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 154)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 154)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 154)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 154)] = 0;
		}
		$signal[0xd9+ (BYTE * 154)] = 0;
	}
	
	#155 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 155)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 155)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 155)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 155)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 155)] = 0;
		}
	}
	
}

#B
{
	my @b1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6, 
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @b2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7, 
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @b3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2, 
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @b4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @b5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @bb1 = (0x00, 0x02, 0x03, 0x10..0x17, 0x20..0x23, 0x40..0x47, 0x50..0x57, 0x60..0x67, 0x74, 0x75, 0x76,
						0x20..0x2f, 0x48..0x4f, 0x58..0x5f, 0x68..0x6b, 0x6e, 0x6f, 0x78, 0x79, 0x7e, 0x7f,
						0x90..0x97, 0xa3, 0xa5, 0xb0..0xb7, 0xc0, 0xc1, 0xc3, 0xc7, 0xd1..0xd5, 0xd7, 0xe0..0xe5, 0xe7, 0xf1..0xf7,
						0x98..0x9f, 0xab, 0xad, 0xaf, 0xbb..0xbf, 0xd8..0xdf, 0xe8..0xef, 0xf8..0xfe);
	my @bb2 = (0x05, 0x06, 0x07, 0x30..0x35, 0x37, 0x77,
						0x08, 0x09, 0x0d, 0x1f,
						0xa0..0xa2,
						0xa8..0xaa, 0xae, 0xc8..0xcf);
	my @bb3 = (0x70..0x73, 
						0xc2, 
						0xac, 0xba);
	my @bbb1 = (0x00..0x07, 0xf0, 0xf1,
						0x08..0x0b, 0x1c..0x1e);
	#14 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 14)] = 0;
		$signal[0x9a + (BYTE * 14)] = 4;
		$state[0xea + (BYTE * 14)] = 0;
		$signal[0xea + (BYTE * 14)] = 4;
		$state[0xc8 + (BYTE * 14)] = 0;
		$signal[0xc8 + (BYTE * 14)] = 3;
		foreach(@b4) {
			$state[$_ + (BYTE * 14)] = 0;
			$signal[$_ + (BYTE * 14)] = 0;
		}
		foreach(@b3) {
			$state[$_ + (BYTE * 14)] = 0;
			$signal[$_ + (BYTE * 14)] = 2;
		}
		foreach(@b2) {
			$state[$_ + (BYTE * 14)] = 0;
			$signal[$_ + (BYTE * 14)] = 1;
		}
		foreach(@b1) {
			$state[$_ + (BYTE * 14)] = 512 * 26;
			$signal[$_ + (BYTE * 14)] = DEFAULT_SIGNAL;
		}
		foreach(@b5) {
			$state[$_ + (BYTE * 14)] = 512 * 27;
			$signal[$_ + (BYTE * 14)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 14)] = 512 * 28;
		$signal[0xc7 + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 14)] = 512 * 28;
		$signal[0x81 + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 14)] = 512 * 28;
		$signal[0x69 + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 14)] = 512 * 29;
		$signal[0xf0 + (BYTE * 14)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 14)] =512 * 156;
		$signal[0xd8 + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 14)] =512 * 157;
		$signal[0xd9 + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 14)] =512 * 158;
		$signal[0xda + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 14)] =512 * 159;
		$signal[0xdb + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 14)] =512 * 160;
		$signal[0xdc + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 14)] =512 * 161;
		$signal[0xdd + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 14)] =512 * 162;
		$signal[0xde + (BYTE * 14)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 14)] =512 * 163;
		$signal[0xdf + (BYTE * 14)] = DEFAULT_SIGNAL;
	}
	
	#26 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 26)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 26)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 26)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 26)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 26)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 26)] = 5;
		}
	}
	
	#27 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 27)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 27)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 27)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 27)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 27)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 27)] = 6;
		}
	}
	
	#28 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 28)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 28)] = 2;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 28)] = 3;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 28)] = 4;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 28)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 28)] = 7;
		}
	}
	
	#29 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (BYTE * 29)] = 0;
			$signal[$_ + (BYTE * 29)] = 2;
		}
		foreach(@bb2) {
			$state[$_ + (BYTE * 29)] = 0;
			$signal[$_ + (BYTE * 29)] = 0;
		}
		foreach(@bb1) {
			$state[$_ + (BYTE * 29)] = 512 * 30;
			$signal[$_ + (BYTE * 29)] = DEFAULT_SIGNAL;
		}
		foreach(@bb3) {
			$state[$_ + (BYTE * 29)] = 512 * 31;
			$signal[$_ + (BYTE * 29)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 29)] = 512 * 32;
		$signal[0x38 + (BYTE * 29)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 29)] = 512 * 33;
		$signal[0x3a + (BYTE * 29)] = DEFAULT_SIGNAL;
	}
	
	#30 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 30)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 30)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 30)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 30)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 30)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 30)] = 5;
		}
	}
	
	#31 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 31)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 31)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 31)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 31)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 31)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 31)] = 6;
		}
	}
	
	#32 состояние 3х-байтные опкоды 38
	{
		foreach(@bbb1) {
			$state[$_ + (BYTE * 32)] = 512 * 34;
			$signal[$_ + (BYTE * 32)] = DEFAULT_SIGNAL;
		}
	}
	
	#33 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 33)] = 512 * 35;
		$signal[0x0f + (BYTE * 33)] = DEFAULT_SIGNAL;
	}
	
	#34 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 34)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 34)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 34)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 34)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 34)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 34)] = 5;
		}
	}
	
	#35 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 35)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 35)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 35)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 35)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 35)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 35)] = 6;
		}
	}
	
	#156 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 156)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 156)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 156)] = 0;
		}
	}
	
	#157 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 157)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 157)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 157)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 157)] = 14;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 157)] = 0;
		}
	}
	
	#158 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 158)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 158)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 158)] = 0;
		}
		$signal[0xe1+ (BYTE * 158)] = 0;
	}
	
	#159 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 159)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 159)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 159)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 159)] = 0;
		}
	}
	
	#160 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 160)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 160)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 160)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 160)] = 0;
		}
	}
	
	#161 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 161)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 161)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 161)] = 94;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 161)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 161)] = 0;
		}
	}
	
	#162 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 162)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 162)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 162)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 162)] = 0;
		}
		$signal[0xd9+ (BYTE * 162)] = 0;
	}
	
	#163 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 163)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 163)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 163)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 163)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 163)] = 0;
		}
	}
	
}

#C
{
	my @c1 = (0x00..0x03, 0x10..0x13, 0x20..0x23, 0x30..0x33, 0x62, 0x63, 0x84..0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08..0x0b, 0x18..0x1b, 0x28..0x2b, 0x38..0x3b, 0x88..0x8f, 0xfe, 0xff);
	my @c2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @c3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3,
					 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @c4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5, 
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @c5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @cc1 = (0x00, 0x02, 0x03, 0x10..0x17, 0x20..0x23, 0x40..0x47, 0x50..0x57, 0x60..0x67, 0x74, 0x75, 0x76,
						0x20..0x2f, 0x48..0x4f, 0x58..0x5f, 0x68..0x6b, 0x6e, 0x6f, 0x78, 0x79, 0x7e, 0x7f,
						0x90..0x97, 0xa3, 0xa5, 0xb0..0xb7, 0xc0, 0xc1, 0xc3, 0xc7, 0xd1..0xd5, 0xd7, 0xe0..0xe5, 0xe7, 0xf1..0xf7,
						0x98..0x9f, 0xab, 0xad, 0xaf, 0xbb..0xbf, 0xd8..0xdf, 0xe8..0xef, 0xf8..0xfe);
	my @cc2 = (0x05, 0x06, 0x07, 0x30..0x35, 0x37, 0x77,
						0x08, 0x09, 0x0d, 0x1f,
						0xa0..0xa2,
						0xa8..0xaa, 0xae, 0xc8..0xcf);
	my @cc3 = (0x70..0x73, 
						0xc2, 
						0xac, 0xba);
	my @ccc1 = (0x00..0x07, 0xf0, 0xf1,
						0x08..0x0b, 0x1c..0x1e);
	#11 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 11)] = 0;
		$signal[0x9a + (BYTE * 11)] = 6;
		$state[0xea + (BYTE * 11)] = 0;
		$signal[0xea + (BYTE * 11)] = 6;
		$state[0xc8 + (BYTE * 11)] = 0;
		$signal[0xc8 + (BYTE * 11)] = 3;
		$state[0xc2 + (BYTE * 11)] = 0;
		$signal[0xc2 + (BYTE * 11)] = 2;
		$state[0xca + (BYTE * 11)] = 0;
		$signal[0xca + (BYTE * 11)] = 2;
		foreach(@c4) {
			$state[$_ + (BYTE * 11)] = 0;
			$signal[$_ + (BYTE * 11)] = 0;
		}
		foreach(@c3) {
			$state[$_ + (BYTE * 11)] = 0;
			$signal[$_ + (BYTE * 11)] = 4;
		}
		foreach(@c2) {
			$state[$_ + (BYTE * 11)] = 0;
			$signal[$_ + (BYTE * 11)] = 1;
		}
		foreach(@c1) {
			$state[$_ + (BYTE * 11)] = 512 * 36;
			$signal[$_ + (BYTE * 11)] = DEFAULT_SIGNAL;
		}
		foreach(@c5) {
			$state[$_ + (BYTE * 11)] = 512 * 37;
			$signal[$_ + (BYTE * 11)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 11)] = 512 * 38;
		$signal[0xc7 + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 11)] = 512 * 38;
		$signal[0x81 + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 11)] = 512 * 38;
		$signal[0x69 + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 11)] = 512 * 39;
		$signal[0xf0 + (BYTE * 11)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 11)] =512 * 164;
		$signal[0xd8 + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 11)] =512 * 165;
		$signal[0xd9 + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 11)] =512 * 166;
		$signal[0xda + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 11)] =512 * 167;
		$signal[0xdb + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 11)] =512 * 168;
		$signal[0xdc + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 11)] =512 * 169;
		$signal[0xdd + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 11)] =512 * 170;
		$signal[0xde + (BYTE * 11)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 11)] =512 * 171;
		$signal[0xdf + (BYTE * 11)] = DEFAULT_SIGNAL;
	}
	
	#36 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 36)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 36)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 36)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 36)] = 2;
		}
	}
	
	#37 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 37)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 37)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 37)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 37)] = 3;
		}
	}
	
	#38 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 38)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 38)] = 4;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 38)] = 5;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 38)] = 6;
		}
	}
	
	#39 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (BYTE * 39)] = 0;
			$signal[$_ + (BYTE * 39)] = 4;
		}
		foreach(@cc2) {
			$state[$_ + (BYTE * 39)] = 0;
			$signal[$_ + (BYTE * 39)] = 0;
		}
		foreach(@cc1) {
			$state[$_ + (BYTE * 39)] = 512 * 40;
			$signal[$_ + (BYTE * 39)] = DEFAULT_SIGNAL;
		}
		foreach(@cc3) {
			$state[$_ + (BYTE * 39)] = 512 * 41;
			$signal[$_ + (BYTE * 39)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 39)] = 512 * 42;
		$signal[0x38 + (BYTE * 39)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 39)] = 512 * 43;
		$signal[0x3a + (BYTE * 39)] = DEFAULT_SIGNAL;
	}
	
	#40 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 40)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 40)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 40)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 40)] = 2;
		}
	}
	
	#41 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 41)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 41)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 41)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 41)] = 3;
		}
	}
	
	#42 состояние 3х-байтные опкоды 38
	{
		foreach(@ccc1) {
			$state[$_ + (BYTE * 42)] = 512 * 44;
			$signal[$_ + (BYTE * 42)] = DEFAULT_SIGNAL;
		}
	}
	
	#43 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 43)] =512 *  45;
		$signal[0x0f + (BYTE * 43)] = DEFAULT_SIGNAL;
	}
	
	#44 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 44)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 44)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 44)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 44)] = 2;
		}
	}
	
	#45 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 45)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 45)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 45)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 45)] = 3;
		}
	}
	
	#164 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 164)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 164)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 164)] = 0;
		}
	}
	
	#165 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 165)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 165)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 165)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 165)] = 28;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 165)] = 0;
		}
	}
	
	#166 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 166)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 166)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 166)] = 0;
		}
		$signal[0xe1+ (BYTE * 166)] = 0;
	}
	
	#167 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 167)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 167)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 167)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 167)] = 0;
		}
	}
	
	#168 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 168)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 168)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 168)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 168)] = 0;
		}
	}
	
	#169 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 169)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 169)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 169)] = 108;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 169)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 169)] = 0;
		}
	}
	
	#170 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 170)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 170)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 170)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 170)] = 0;
		}
		$signal[0xd9+ (BYTE * 170)] = 0;
	}
	
	#171 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 171)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 171)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 171)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 171)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 171)] = 0;
		}
	}	

}

#D
{
	my @d1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @d2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @d3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2,
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @d4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @d5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @dd1 = (0x00, 0x02, 0x03, 0x10..0x17, 0x20..0x23, 0x40..0x47, 0x50..0x57, 0x60..0x67, 0x74, 0x75, 0x76,
						0x20..0x2f, 0x48..0x4f, 0x58..0x5f, 0x68..0x6b, 0x6e, 0x6f, 0x78, 0x79, 0x7e, 0x7f,
						0x90..0x97, 0xa3, 0xa5, 0xb0..0xb7, 0xc0, 0xc1, 0xc3, 0xc7, 0xd1..0xd5, 0xd7, 0xe0..0xe5, 0xe7, 0xf1..0xf7,
						0x98..0x9f, 0xab, 0xad, 0xaf, 0xbb..0xbf, 0xd8..0xdf, 0xe8..0xef, 0xf8..0xfe);
	my @dd2 = (0x05, 0x06, 0x07, 0x30..0x35, 0x37, 0x77,
						0x08, 0x09, 0x0d, 0x1f,
						0xa0..0xa2,
						0xa8..0xaa, 0xae, 0xc8..0xcf);
	my @dd3 = (0x70..0x73, 
						0xc2, 
						0xac, 0xba);
	my @ddd1 = (0x00..0x07, 0xf0, 0xf1,
						0x08..0x0b, 0x1c..0x1e);
	#12 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 12)] = 0;
		$signal[0x9a + (BYTE * 12)] = 4;
		$state[0xea + (BYTE * 12)] = 0;
		$signal[0xea + (BYTE * 12)] = 4;
		$state[0xc8 + (BYTE * 12)] = 0;
		$signal[0xc8 + (BYTE * 12)] = 3;
		foreach(@d4) {
			$state[$_ + (BYTE * 12)] = 0;
			$signal[$_ + (BYTE * 12)] = 0;
		}
		foreach(@d3) {
			$state[$_ + (BYTE * 12)] = 0;
			$signal[$_ + (BYTE * 12)] = 2;
		}
		foreach(@d2) {
			$state[$_ + (BYTE * 12)] = 0;
			$signal[$_ + (BYTE * 12)] = 1;
		}
		foreach(@d1) {
			$state[$_ + (BYTE * 12)] = 512 * 46;
			$signal[$_ + (BYTE * 12)] = DEFAULT_SIGNAL;
		}
		foreach(@d5) {
			$state[$_ + (BYTE * 12)] = 512 * 47;
			$signal[$_ + (BYTE * 12)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 12)] = 512 * 48;
		$signal[0xc7 + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 12)] = 512 * 48;
		$signal[0x81 + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 12)] = 512 * 48;
		$signal[0x69 + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 12)] = 512 * 49;
		$signal[0xf0 + (BYTE * 12)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 12)] =512 * 172;
		$signal[0xd8 + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 12)] =512 * 173;
		$signal[0xd9 + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 12)] =512 * 174;
		$signal[0xda + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 12)] =512 * 175;
		$signal[0xdb + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 12)] =512 * 176;
		$signal[0xdc + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 12)] =512 * 177;
		$signal[0xdd + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 12)] =512 * 178;
		$signal[0xde + (BYTE * 12)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 12)] =512 * 179;
		$signal[0xdf + (BYTE * 12)] = DEFAULT_SIGNAL;
	}
	
	#46 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 46)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 46)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 46)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 46)] = 2;
		}
	}
	
	#47 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 47)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 47)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 47)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 47)] = 3;
		}
	}
	
	#48 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 48)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 48)] = 2;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 48)] = 3;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 48)] = 4;
		}
	}
	
	#49 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (BYTE * 49)] = 0;
			$signal[$_ + (BYTE * 49)] = 2;
		}
		foreach(@dd2) {
			$state[$_ + (BYTE * 29)] = 0;
			$signal[$_ + (BYTE * 29)] = 0;
		}
		foreach(@dd1) {
			$state[$_ + (BYTE * 29)] = 512 * 50;
			$signal[$_ + (BYTE * 29)] = DEFAULT_SIGNAL;
		}
		foreach(@dd3) {
			$state[$_ + (BYTE * 29)] = 512 * 51;
			$signal[$_ + (BYTE * 29)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 29)] = 512 * 52;
		$signal[0x38 + (BYTE * 29)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 29)] = 512 * 53;
		$signal[0x3a + (BYTE * 29)] = DEFAULT_SIGNAL;
	}
	
	#50 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 50)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 50)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 50)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 50)] = 2;
		}
	}
	
	#51 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 51)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 51)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 51)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 51)] = 3;
		}
	}
	
	#52 состояние 3х-байтные опкоды 38
	{
		foreach(@ddd1) {
			$state[$_ + (BYTE * 52)] = 512 * 54;
			$signal[$_ + (BYTE * 52)] = DEFAULT_SIGNAL;
		}
	}
	
	#53 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 53)] =512 *  55;
		$signal[0x0f + (BYTE * 53)] = DEFAULT_SIGNAL;
	}
	
	#54 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 54)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 54)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 54)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 54)] = 2;
		}
	}
	
	#55 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 55)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 55)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 55)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 55)] = 3;
		}
	}
	
	#172 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 172)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 172)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 172)] = 0;
		}
	}
	
	#173 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 173)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 173)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 173)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 173)] = 14;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 173)] = 0;
		}
	}
	
	#174 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 174)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 174)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 174)] = 0;
		}
		$signal[0xe1+ (BYTE * 174)] = 0;
	}
	
	#175 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 175)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 175)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 175)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 175)] = 0;
		}
	}
	
	#176 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 176)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 176)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 176)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 176)] = 0;
		}
	}
	
	#177 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 177)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 177)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 177)] = 94;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 177)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 177)] = 0;
		}
	}
	
	#178 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 178)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 178)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 178)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 178)] = 0;
		}
		$signal[0xd9+ (BYTE * 178)] = 0;
	}
	
	#179 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 179)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 179)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 179)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 179)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 179)] = 0;
		}
	}
	
}

#E
{
	my @e1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @e2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @e3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3,
					 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @e4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @e5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @ee1 = (0x2a, 0x2c, 0x2d, 0x58..0x5a, 0x5c..0x5f, 0x7c, 0x7d,
						0xd0, 0xd6, 0xe6, 0xf0);
	my @ee2 = (0x70, 0xc2);
	my @eee1 = (0xf0, 0xf1);
	#3 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 3)] = 0;
		$signal[0x9a + (BYTE * 3)] = 6;
		$state[0xea + (BYTE * 3)] = 0;
		$signal[0xea + (BYTE * 3)] = 6;
		$state[0xc8 + (BYTE * 3)] = 0;
		$signal[0xc8 + (BYTE * 3)] = 3;
		$state[0xc2 + (BYTE * 3)] = 0;
		$signal[0xc2 + (BYTE * 3)] = 2;
		$state[0xca + (BYTE * 3)] = 0;
		$signal[0xca + (BYTE * 3)] = 2;
		foreach(@e4) {
			$state[$_ + (BYTE * 3)] = 0;
			$signal[$_ + (BYTE * 3)] = 0;
		}
		foreach(@e3) {
			$state[$_ + (BYTE * 3)] = 0;
			$signal[$_ + (BYTE * 3)] = 4;
		}
		foreach(@e2) {
			$state[$_ + (BYTE * 3)] = 0;
			$signal[$_ + (BYTE * 3)] = 1;
		}
		foreach(@e1) {
			$state[$_ + (BYTE * 3)] =512 *  56;
			$signal[$_ + (BYTE * 3)] = DEFAULT_SIGNAL;
		}
		foreach(@e5) {
			$state[$_ + (BYTE * 3)] = 512 * 57;
			$signal[$_ + (BYTE * 3)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 3)] = 512 * 58;
		$signal[0xc7 + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 3)] = 512 * 58;
		$signal[0x81 + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 3)] = 512 * 58;
		$signal[0x69 + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 3)] = 512 * 59;
		$signal[0xf0 + (BYTE * 3)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 3)] =512 * 180;
		$signal[0xd8 + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 3)] =512 * 181;
		$signal[0xd9 + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 3)] =512 * 182;
		$signal[0xda + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 3)] =512 * 183;
		$signal[0xdb + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 3)] =512 * 184;
		$signal[0xdc + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 3)] =512 * 185;
		$signal[0xdd + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 3)] =512 * 186;
		$signal[0xde + (BYTE * 3)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 3)] =512 * 187;
		$signal[0xdf + (BYTE * 3)] = DEFAULT_SIGNAL;
	}
	
	#56 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 56)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 56)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 56)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 56)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 56)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 56)] = 5;
		}
	}
	
	#57 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 57)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 57)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 57)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 57)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 57)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 57)] = 6;
		}
	}
	
	#58 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 58)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 58)] = 4;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 58)] = 5;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 58)] = 6;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 58)] = 8;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 58)] = 9;
		}
	}
	
	#59 состояние 2х-байтные опкоды
	{
		foreach(@ee1) {
			$state[$_ + (BYTE * 59)] = 512 * 60;
			$signal[$_ + (BYTE * 59)] = DEFAULT_SIGNAL;
		}
		foreach(@ee2) {
			$state[$_ + (BYTE * 59)] = 512 * 61;
			$signal[$_ + (BYTE * 59)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 59)] = 512 * 2;
		$signal[0x38 + (BYTE * 59)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 59)] = 512 * 63;
		$signal[0x3a + (BYTE * 59)] = DEFAULT_SIGNAL;
	}
	
	#60 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 60)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 60)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 60)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 60)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 60)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 60)] = 5;
		}
	}
	
	#61 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 61)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 61)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 61)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 61)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 61)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 61)] = 6;
		}
	}
	
	#62 состояние 3х-байтные опкоды 38
	{
		foreach(@eee1) {
			$state[$_ + (BYTE * 62)] = 512 * 64;
			$signal[$_ + (BYTE * 22)] = DEFAULT_SIGNAL;
		}
	}
	
	#63 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 63)] = 512 * 65;
		$signal[0x0f + (BYTE * 63)] = DEFAULT_SIGNAL;
	}
	
	#64 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 64)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 64)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 64)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 64)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 64)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 64)] = 5;
		}
	}
	
	#65 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 65)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 65)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 65)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 65)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 65)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 65)] = 6;
		}
	}
	
	#180 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 180)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 180)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 180)] = 0;
		}
	}
	
	#181 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 181)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 181)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 181)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 181)] = 28;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 181)] = 0;
		}
	}
	
	#182 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 182)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 182)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 182)] = 0;
		}
		$signal[0xe1+ (BYTE * 182)] = 0;
	}
	
	#183 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 183)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 183)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 183)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 183)] = 0;
		}
	}
	
	#184 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 184)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 184)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 184)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 184)] = 0;
		}
	}
	
	#185 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 185)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 185)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 185)] = 108;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 185)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 185)] = 0;
		}
	}
	
	#186 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 186)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 186)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 186)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 186)] = 0;
		}
		$signal[0xd9+ (BYTE * 186)] = 0;
	}
	
	#187 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 187)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 187)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 187)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 187)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 187)] = 0;
		}
	}	

}

#F
{
	my @f1 = (0x00..0x03, 0x10..0x13, 0x20..0x23, 0x30..0x33, 0x62, 0x63, 0x84..0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08..0x0b, 0x18..0x1b, 0x28..0x2b, 0x38..0x3b, 0x88..0x8f, 0xfe, 0xff);
	my @f2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @f3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3,
					 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @f4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @f5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @ff1 = (0x10..0x12, 0x51,
					 0x2a, 0x2c, 0x2d, 0x58..0x5a, 0x5c..0x5f, 0x7c, 0x7d,
					 0xd0, 0xd6, 0xe6, 0xf0);
	my @ff2 = (0x70, 0xc2);
	my @fff1 = (0xf0, 0xf1);
	#5 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 5)] = 0;
		$signal[0x9a + (BYTE * 5)] = 6;
		$state[0xea + (BYTE * 5)] = 0;
		$signal[0xea + (BYTE * 5)] = 6;
		$state[0xc8 + (BYTE * 5)] = 0;
		$signal[0xc8 + (BYTE * 5)] = 3;
		$state[0xc2 + (BYTE * 5)] = 0;
		$signal[0xc2 + (BYTE * 5)] = 2;
		$state[0xca + (BYTE * 5)] = 0;
		$signal[0xca + (BYTE * 5)] = 2;
		foreach(@f4) {
			$state[$_ + (BYTE * 5)] = 0;
			$signal[$_ + (BYTE * 5)] = 0;
		}
		foreach(@f3) {
			$state[$_ + (BYTE * 5)] = 0;
			$signal[$_ + (BYTE * 5)] = 4;
		}
		foreach(@f2) {
			$state[$_ + (BYTE * 5)] = 0;
			$signal[$_ + (BYTE * 5)] = 1;
		}
		foreach(@f1) {
			$state[$_ + (BYTE * 5)] = 512 * 66;
			$signal[$_ + (BYTE * 5)] = DEFAULT_SIGNAL;
		}
		foreach(@f5) {
			$state[$_ + (BYTE * 5)] = 512 * 67;
			$signal[$_ + (BYTE * 5)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 5)] = 512 * 68;
		$signal[0xc7 + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 5)] =512 *  68;
		$signal[0x81 + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 5)] = 512 * 68;
		$signal[0x69 + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 5)] = 512 * 69;
		$signal[0xf0 + (BYTE * 5)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 5)] =512 * 188;
		$signal[0xd8 + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 5)] =512 * 189;
		$signal[0xd9 + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 5)] =512 * 190;
		$signal[0xda + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 5)] =512 * 191;
		$signal[0xdb + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 5)] =512 * 192;
		$signal[0xdc + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 5)] =512 * 193;
		$signal[0xdd + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 5)] =512 * 194;
		$signal[0xde + (BYTE * 5)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 5)] =512 * 195;
		$signal[0xdf + (BYTE * 5)] = DEFAULT_SIGNAL;
	}
	
	#66 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 66)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 66)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 66)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 66)] = 2;
		}
	}
	
	#67 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 67)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 67)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 67)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 67)] = 3;
		}
	}
	
	#68 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 68)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 68)] = 4;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 68)] = 5;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 68)] = 6;
		}
	}
	
	#69 состояние 2х-байтные опкоды
	{
		foreach(@ff1) {
			$state[$_ + (BYTE * 69)] = 512 * 70;
			$signal[$_ + (BYTE * 69)] = DEFAULT_SIGNAL;
		}
		foreach(@ff2) {
			$state[$_ + (BYTE * 69)] = 512 * 71;
			$signal[$_ + (BYTE * 69)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 69)] = 512 * 72;
		$signal[0x38 + (BYTE * 69)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 69)] = 512 * 73;
		$signal[0x3a + (BYTE * 69)] = DEFAULT_SIGNAL;
	}
	
	#70 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 70)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 70)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 70)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 70)] = 2;
		}
	}
	
	#71 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 71)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 71)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 71)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 71)] = 3;
		}
	}
	
	#72 состояние 3х-байтные опкоды 38
	{
		foreach(@fff1) {
			$state[$_ + (BYTE * 72)] = 512 * 74;
			$signal[$_ + (BYTE * 72)] = DEFAULT_SIGNAL;
		}
	}
	
	#73 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 73)] = 512 * 75;
		$signal[0x0f + (BYTE * 73)] = DEFAULT_SIGNAL;
	}
	
	#74 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 74)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 74)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 74)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 74)] = 2;
		}
	}
	
	#75 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 75)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 75)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 75)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 75)] = 3;
		}
	}
	
	#188 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 188)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 188)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 188)] = 0;
		}
	}
	
	#189 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 189)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 189)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 189)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 189)] = 28;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 189)] = 0;
		}
	}
	
	#190 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 190)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 190)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 190)] = 0;
		}
		$signal[0xe1+ (BYTE * 190)] = 0;
	}
	
	#191 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 191)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 191)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 191)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 191)] = 0;
		}
	}
	
	#192 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 192)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 192)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 192)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 192)] = 0;
		}
	}
	
	#193 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 193)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 193)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 193)] = 108;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 193)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 193)] = 0;
		}
	}
	
	#194 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 194)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 194)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 194)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 194)] = 0;
		}
		$signal[0xd9+ (BYTE * 194)] = 0;
	}
	
	#195 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 195)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 195)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 195)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 195)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 195)] = 0;
		}
	}	

}

#G
{
	my @g1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6, 
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @g2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7, 
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @g3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2, 
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @g4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @g5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @gg1 = (0x10..0x12, 0x51, 
						0x2a, 0x2c, 0x2d, 0x58..0x5a, 0x5c..0x5f, 0x7c, 0x7d,
						0xd0, 0xd6, 0xe6, 0xf0);
	my @gg2 = (0x70, 0xc2);
	my @ggg1 = (0xf0, 0xf1);
	#4 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 4)] = 0;
		$signal[0x9a + (BYTE * 4)] = 4;
		$state[0xea + (BYTE * 4)] = 0;
		$signal[0xea + (BYTE * 4)] = 4;
		$state[0xc8 + (BYTE * 4)] = 0;
		$signal[0xc8 + (BYTE * 4)] = 3;
		foreach(@g4) {
			$state[$_ + (BYTE * 4)] = 0;
			$signal[$_ + (BYTE * 4)] = 0;
		}
		foreach(@g3) {
			$state[$_ + (BYTE * 4)] = 0;
			$signal[$_ + (BYTE * 4)] = 2;
		}
		foreach(@g2) {
			$state[$_ + (BYTE * 4)] = 0;
			$signal[$_ + (BYTE * 4)] = 1;
		}
		foreach(@g1) {
			$state[$_ + (BYTE * 4)] = 512 * 76;
			$signal[$_ + (BYTE * 4)] = DEFAULT_SIGNAL;
		}
		foreach(@g5) {
			$state[$_ + (BYTE * 4)] = 512 * 77;
			$signal[$_ + (BYTE * 4)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 4)] = 512 * 78;
		$signal[0xc7 + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 4)] = 512 * 78;
		$signal[0x81 + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 4)] = 512 * 78;
		$signal[0x69 + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 4)] = 512 * 79;
		$signal[0xf0 + (BYTE * 4)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 4)] =512 * 188;
		$signal[0xd8 + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 4)] =512 * 189;
		$signal[0xd9 + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 4)] =512 * 190;
		$signal[0xda + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 4)] =512 * 191;
		$signal[0xdb + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 4)] =512 * 192;
		$signal[0xdc + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 4)] =512 * 193;
		$signal[0xdd + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 4)] =512 * 194;
		$signal[0xde + (BYTE * 4)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 4)] =512 * 195;
		$signal[0xdf + (BYTE * 4)] = DEFAULT_SIGNAL;
	}
	
	#76 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 76)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 76)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 76)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 76)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 76)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 76)] = 5;
		}
	}
	
	#77 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 77)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 77)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 77)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 77)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 77)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 77)] = 6;
		}
	}
	
	#78 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 78)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 78)] = 2;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 78)] = 3;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 78)] = 4;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 78)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 78)] = 7;
		}
	}
	
	#79 состояние 2х-байтные опкоды
	{
		foreach(@gg1) {
			$state[$_ + (BYTE * 79)] = 512 * 80;
			$signal[$_ + (BYTE * 79)] = DEFAULT_SIGNAL;
		}
		foreach(@gg2) {
			$state[$_ + (BYTE * 79)] = 512 * 81;
			$signal[$_ + (BYTE * 79)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 79)] = 512 * 82;
		$signal[0x38 + (BYTE * 79)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 79)] = 512 * 83;
		$signal[0x3a + (BYTE * 79)] = DEFAULT_SIGNAL;
	}
	
	#80 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 80)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 80)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 80)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 80)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 80)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 80)] = 5;
		}
	}
	
	#81 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 81)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 81)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 81)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 81)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 81)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 81)] = 6;
		}
	}
	
	#82 состояние 3х-байтные опкоды 38
	{
		foreach(@ggg1) {
			$state[$_ + (BYTE * 82)] = 512 * 84;
			$signal[$_ + (BYTE * 82)] = DEFAULT_SIGNAL;
		}
	}
	
	#83 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 83)] = 512 * 85;
		$signal[0x0f + (BYTE * 83)] = DEFAULT_SIGNAL;
	}
	
	#84 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 84)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 84)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 84)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 84)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 84)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 84)] = 5;
		}
	}
	
	#85 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 85)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 85)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 85)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 85)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 85)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 85)] = 6;
		}
	}
	
	#188 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 188)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 188)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 188)] = 0;
		}
	}
	
	#189 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 189)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 189)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 189)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 189)] = 14;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 189)] = 0;
		}
	}
	
	#190 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 190)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 190)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 190)] = 0;
		}
		$signal[0xe1+ (BYTE * 190)] = 0;
	}
	
	#191 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 191)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 191)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 191)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 191)] = 0;
		}
	}
	
	#192 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 192)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 192)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 192)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 192)] = 0;
		}
	}
	
	#193 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 193)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 193)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 193)] = 94;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 193)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 193)] = 0;
		}
	}
	
	#194 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 194)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 194)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 194)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 194)] = 0;
		}
		$signal[0xd9+ (BYTE * 194)] = 0;
	}
	
	#195 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 195)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 195)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 195)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 195)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 195)] = 0;
		}
	}
	
}

#H
{
	my @h1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @h2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @h3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2,
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @h4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @h5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @hh1 = (0x10..0x12, 0x51,
						0x2a, 0x2c, 0x2d, 0x58..0x5a, 0x5c..0x5f, 0x7c, 0x7d,
						0xd0, 0xd6, 0xe6, 0xf0);
	my @hh2 = (0x70, 0xc2);
	my @hhh1 = (0xf0, 0xf1);
	#6 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 6)] = 0;
		$signal[0x9a + (BYTE * 6)] = 4;
		$state[0xea + (BYTE * 6)] = 0;
		$signal[0xea + (BYTE * 6)] = 4;
		$state[0xc8 + (BYTE * 6)] = 0;
		$signal[0xc8 + (BYTE * 6)] = 3;
		foreach(@h4) {
			$state[$_ + (BYTE * 6)] = 0;
			$signal[$_ + (BYTE * 6)] = 0;
		}
		foreach(@h3) {
			$state[$_ + (BYTE * 6)] = 0;
			$signal[$_ + (BYTE * 6)] = 2;
		}
		foreach(@h2) {
			$state[$_ + (BYTE * 6)] = 0;
			$signal[$_ + (BYTE * 6)] = 1;
		}
		foreach(@h1) {
			$state[$_ + (BYTE * 6)] =512 *  86;
			$signal[$_ + (BYTE * 6)] = DEFAULT_SIGNAL;
		}
		foreach(@h5) {
			$state[$_ + (BYTE * 6)] = 512 * 87;
			$signal[$_ + (BYTE * 6)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 6)] =512 *  88;
		$signal[0xc7 + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 6)] =512 *  88;
		$signal[0x81 + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 6)] =512 *  88;
		$signal[0x69 + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 6)] =512 *  89;
		$signal[0xf0 + (BYTE * 6)] = DEFAULT_SIGNAL;
		#coprocessor
		$state[0xd8 + (BYTE * 6)] =512 * 196;
		$signal[0xd8 + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xd9 + (BYTE * 6)] =512 * 197;
		$signal[0xd9 + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xda + (BYTE * 6)] =512 * 198;
		$signal[0xda + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xdb + (BYTE * 6)] =512 * 199;
		$signal[0xdb + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xdc + (BYTE * 6)] =512 * 200;
		$signal[0xdc + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xdd + (BYTE * 6)] =512 * 201;
		$signal[0xdd + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xde + (BYTE * 6)] =512 * 202;
		$signal[0xde + (BYTE * 6)] = DEFAULT_SIGNAL;
		$state[0xdf + (BYTE * 6)] =512 * 203;
		$signal[0xdf + (BYTE * 6)] = DEFAULT_SIGNAL;
	}
	
	#86 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 86)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 86)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 86)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 86)] = 2;
		}
	}
	
	#87 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 87)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 87)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 87)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 87)] = 3;
		}
	}
	
	#88 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 88)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 88)] = 2;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 88)] = 3;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 88)] = 4;
		}
	}
	
	#89 состояние 2х-байтные опкоды
	{
		foreach(@hh1) {
			$state[$_ + (BYTE * 29)] = 512 * 90;
			$signal[$_ + (BYTE * 29)] = DEFAULT_SIGNAL;
		}
		foreach(@hh2) {
			$state[$_ + (BYTE * 29)] = 512 * 91;
			$signal[$_ + (BYTE * 29)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 29)] = 512 * 92;
		$signal[0x38 + (BYTE * 29)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 29)] = 512 * 93;
		$signal[0x3a + (BYTE * 29)] = DEFAULT_SIGNAL;
	}
	
	#90 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 90)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 90)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 90)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 90)] = 2;
		}
	}
	
	#91 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 91)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 91)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 91)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 91)] = 3;
		}
	}
	
	#92 состояние 3х-байтные опкоды 38
	{
		foreach(@hhh1) {
			$state[$_ + (BYTE * 92)] = 512 * 94;
			$signal[$_ + (BYTE * 92)] = DEFAULT_SIGNAL;
		}
	}
	
	#93 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (BYTE * 93)] = 512 * 95;
		$signal[0x0f + (BYTE * 93)] = DEFAULT_SIGNAL;
	}
	
	#94 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 94)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 94)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 94)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 94)] = 2;
		}
	}
	
	#95 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 95)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 95)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 95)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 95)] = 3;
		}
	}
	
	#196 состояние d8
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 196)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 196)] = 4;
		}
		for(0xc0..0xff) {
			$signal[$_ + (BYTE * 196)] = 0;
		}
	}
	
	#197 состояние d9
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 197)] = 0;
		}
		foreach(@d9_1) {
			$signal[$_ + (BYTE * 197)] = 4;
		}
		foreach(@d9_2) {
			$signal[$_ + (BYTE * 197)] = 2;
		}
		foreach(@d9_3) {
			$signal[$_ + (BYTE * 197)] = 14;
		}
		foreach(@d9_4) {
			$signal[$_ + (BYTE * 197)] = 0;
		}
	}
	
	#198 состояние da
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 198)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 198)] = 4;
		}
		for(0xc0..0xdf) {
			$signal[$_ + (BYTE * 198)] = 0;
		}
		$signal[0xe1+ (BYTE * 198)] = 0;
	}
	
	#199 состояние db
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 199)] = 0;
		}
		foreach(@db_1) {
			$signal[$_ + (BYTE * 199)] = 4;
		}
		foreach(@db_2) {
			$signal[$_ + (BYTE * 199)] = 10;
		}
		foreach(@db_3) {
			$signal[$_ + (BYTE * 199)] = 0;
		}
	}
	
	#200 состояние dc
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 200)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 200)] = 8;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 200)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 200)] = 0;
		}
	}
	
	#201 состояние dd
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 201)] = 0;
		}
		foreach(@dd_1) {
			$signal[$_ + (BYTE * 201)] = 8;
		}
		foreach(@dd_2) {
			$signal[$_ + (BYTE * 201)] = 94;
		}
		foreach(@dd_3) {
			$signal[$_ + (BYTE * 201)] = 2;
		}
		foreach(@dd_4) {
			$signal[$_ + (BYTE * 201)] = 0;
		}
	}
	
	#202 состояние de
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 202)] = 0;
		}
		for(0x00..0xbf) {
			$signal[$_ + (BYTE * 202)] = 2;
		}
		for(0xc0..0xcf) {
			$signal[$_ + (BYTE * 202)] = 0;
		}
		for(0xe0..0xff) {
			$signal[$_ + (BYTE * 202)] = 0;
		}
		$signal[0xd9+ (BYTE * 202)] = 0;
	}
	
	#203 состояние df
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 203)] = 0;
		}
		foreach(@df_1) {
			$signal[$_ + (BYTE * 203)] = 2;
		}
		foreach(@df_2) {
			$signal[$_ + (BYTE * 203)] = 8;
		}
		foreach(@df_3) {
			$signal[$_ + (BYTE * 203)] = 10;
		}
		foreach(@df_4) {
			$signal[$_ + (BYTE * 203)] = 0;
		}
	}
	
}

#I
{
	my @i1 = (0x00..0x03, 0x10..0x13, 0x20..0x23, 0x30..0x33, 0x62, 0x63, 0x84..0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08..0x0b, 0x18..0x1b, 0x28..0x2b, 0x38..0x3b, 0x88..0x8f, 0xfe, 0xff);
	my @i2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @i3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3,
					 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @i4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5, 
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @i5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @ii1 = (0x10..0x12, 0x16, 0x51..0x53,
					 0x2a, 0x2c, 0x2d, 0x58..0x5f, 0x6f, 0x7e, 0x7f,
					 0xd6, 0xe6,
					 0xb8, 0xbc, 0xbd);
	my @ii2 = (0x70, 0xc2);
	my @iii1 = (0xf5, 0xf7);
	#9 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 9)] = 0;
		$signal[0x9a + (BYTE * 9)] = 6;
		$state[0xea + (BYTE * 9)] = 0;
		$signal[0xea + (BYTE * 9)] = 6;
		$state[0xc8 + (BYTE * 9)] = 0;
		$signal[0xc8 + (BYTE * 9)] = 3;
		$state[0xc2 + (BYTE * 9)] = 0;
		$signal[0xc2 + (BYTE * 9)] = 2;
		$state[0xca + (BYTE * 9)] = 0;
		$signal[0xca + (BYTE * 9)] = 2;
		foreach(@i4) {
			$state[$_ + (BYTE * 9)] = 0;
			$signal[$_ + (BYTE * 9)] = 0;
		}
		foreach(@i3) {
			$state[$_ + (BYTE * 9)] = 0;
			$signal[$_ + (BYTE * 9)] = 4;
		}
		foreach(@i2) {
			$state[$_ + (BYTE * 9)] = 0;
			$signal[$_ + (BYTE * 9)] = 1;
		}
		foreach(@i1) {
			$state[$_ + (BYTE * 9)] = 512 * 96;
			$signal[$_ + (BYTE * 9)] = DEFAULT_SIGNAL;
		}
		foreach(@i5) {
			$state[$_ + (BYTE * 9)] = 512 * 97;
			$signal[$_ + (BYTE * 9)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 9)] = 512 * 98;
		$signal[0xc7 + (BYTE * 9)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 9)] = 512 * 98;
		$signal[0x81 + (BYTE * 9)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 9)] = 512 * 98;
		$signal[0x69 + (BYTE * 9)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 9)] = 512 * 99;
		$signal[0xf0 + (BYTE * 9)] = DEFAULT_SIGNAL;
	}
	
	#96 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 96)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 96)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 96)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 96)] = 2;
		}
	}
	
	#97 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 97)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 97)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 97)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 97)] = 3;
		}
	}
	
	#98 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 98)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 98)] = 4;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 98)] = 5;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 98)] = 6;
		}
	}
	
	#99 состояние 2х-байтные опкоды
	{
		foreach(@ii1) {
			$state[$_ + (BYTE * 99)] = 512 * 100;
			$signal[$_ + (BYTE * 99)] = DEFAULT_SIGNAL;
		}
		foreach(@ii2) {
			$state[$_ + (BYTE * 99)] = 512 * 101;
			$signal[$_ + (BYTE * 99)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 99)] = 512 * 102;
		$signal[0x38 + (BYTE * 99)] = DEFAULT_SIGNAL;
	}
	
	#100 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 100)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 100)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 100)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 100)] = 2;
		}
	}
	
	#101 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 101)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 101)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 101)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 101)] = 3;
		}
	}
	
	#102 состояние 3х-байтные опкоды 38
	{
		foreach(@iii1) {
			$state[$_ + (BYTE * 102)] = 512 * 103;
			$signal[$_ + (BYTE * 102)] = DEFAULT_SIGNAL;
		}
	}
	
	#103 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 103)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 103)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 103)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 103)] = 2;
		}
	}
}

#J
{
	my @j1 = (0x00..0x03, 0x10..0x13, 0x20..0x23, 0x30..0x33, 0x62, 0x63, 0x84..0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08..0x0b, 0x18..0x1b, 0x28..0x2b, 0x38..0x3b, 0x88..0x8f, 0xfe, 0xff);
	my @j2	 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @j3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3,
					 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @j4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5, 
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @j5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @jj1 = (0x10..0x12, 0x16, 0x51..0x53,
					 0x2a, 0x2c, 0x2d, 0x58..0x5f, 0x6f, 0x7e, 0x7f,
					 0xd6, 0xe6,
					 0xb8, 0xbc, 0xbd);
	my @jj2 = (0x05, 0x06, 0x07, 0x30..0x35, 0x37, 0x77,
						0x08, 0x09, 0x0d, 0x1f,
						0xa0..0xa2,
						0xa8..0xaa, 0xae, 0xc8..0xcf);
	my @jjj1 = (0x00..0x07, 0xf0, 0xf1,
						0x08..0x0b, 0x1c..0x1e);
	#7 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 7)] = 0;
		$signal[0x9a + (BYTE * 7)] = 6;
		$state[0xea + (BYTE * 7)] = 0;
		$signal[0xea + (BYTE * 7)] = 6;
		$state[0xc8 + (BYTE * 7)] = 0;
		$signal[0xc8 + (BYTE * 7)] = 3;
		$state[0xc2 + (BYTE * 7)] = 0;
		$signal[0xc2 + (BYTE * 7)] = 2;
		$state[0xca + (BYTE * 7)] = 0;
		$signal[0xca + (BYTE * 7)] = 2;
		foreach(@j4) {
			$state[$_ + (BYTE * 7)] = 0;
			$signal[$_ + (BYTE * 7)] = 0;
		}
		foreach(@j3) {
			$state[$_ + (BYTE * 7)] = 0;
			$signal[$_ + (BYTE * 7)] = 4;
		}
		foreach(@j2) {
			$state[$_ + (BYTE * 7)] = 0;
			$signal[$_ + (BYTE * 7)] = 1;
		}
		foreach(@j1) {
			$state[$_ + (BYTE * 7)] = 512 * 104;
			$signal[$_ + (BYTE * 7)] = DEFAULT_SIGNAL;
		}
		foreach(@j5) {
			$state[$_ + (BYTE * 7)] =512 * 105;
			$signal[$_ + (BYTE * 7)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 7)] =512 * 106;
		$signal[0xc7 + (BYTE * 7)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 7)] =512 * 106;
		$signal[0x81 + (BYTE * 7)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 7)] =512 * 106;
		$signal[0x69 + (BYTE * 7)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 7)] =512 * 107;
		$signal[0xf0 + (BYTE * 7)] = DEFAULT_SIGNAL;
	}
	
	#104 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 104)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 104)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 104)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 104)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 104)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 104)] = 5;
		}
	}
	
	#105 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 105)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 105)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 105)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 105)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 105)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 105)] = 6;
		}
	}
	
	#106 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 106)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 106)] = 4;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 106)] = 5;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 106)] = 6;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 106)] = 8;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 106)] = 9;
		}
	}
	
	#107 состояние 2х-байтные опкоды
	{
		foreach(@jj1) {
			$state[$_ + (BYTE * 107)] = 512 * 108;
			$signal[$_ + (BYTE * 107)] = DEFAULT_SIGNAL;
		}
		foreach(@jj2) {
			$state[$_ + (BYTE * 107)] =512 *  109;
			$signal[$_ + (BYTE * 107)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 107)] =512 *  110;
		$signal[0x38 + (BYTE * 107)] = DEFAULT_SIGNAL;
	}
	
	#108 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 108)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 108)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 108)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 108)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 108)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 108)] = 5;
		}
	}
	
	#109 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 109)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 109)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 109)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 109)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 109)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 109)] = 6;
		}
	}
	
	#110 состояние 3х-байтные опкоды 38
	{
		foreach(@jjj1) {
			$state[$_ + (BYTE * 110)] = 512 * 111;
			$signal[$_ + (BYTE * 110)] = DEFAULT_SIGNAL;
		}
	}
	
	#111 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 111)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 111)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 111)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 111)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 111)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 111)] = 5;
		}
	}	
}

#K
{
	my @k1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6, 
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @k2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7, 
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @k3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2, 
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @k4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @k5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @kk1 = (0x10..0x12, 0x16, 0x51..0x53,
						0x2a, 0x2c, 0x2d, 0x58..0x5f, 0x6f, 0x7e, 0x7f,
						0xd6, 0xe6,
						0xb8, 0xbc, 0xbd);
	my @kk2 = (0x70, 0xc2);
	my @kkk1 = (0xf5, 0xf7);
	#8 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 8)] = 0;
		$signal[0x9a + (BYTE * 8)] = 4;
		$state[0xea + (BYTE * 8)] = 0;
		$signal[0xea + (BYTE * 8)] = 4;
		$state[0xc8 + (BYTE * 8)] = 0;
		$signal[0xc8 + (BYTE * 8)] = 3;
		foreach(@k4) {
			$state[$_ + (BYTE * 8)] = 0;
			$signal[$_ + (BYTE * 8)] = 0;
		}
		foreach(@k3) {
			$state[$_ + (BYTE * 8)] = 0;
			$signal[$_ + (BYTE * 8)] = 2;
		}
		foreach(@k2) {
			$state[$_ + (BYTE * 8)] = 0;
			$signal[$_ + (BYTE * 8)] = 1;
		}
		foreach(@k1) {
			$state[$_ + (BYTE * 8)] = 512 * 112;
			$signal[$_ + (BYTE * 8)] = DEFAULT_SIGNAL;
		}
		foreach(@k5) {
			$state[$_ + (BYTE * 8)] = 512 * 113;
			$signal[$_ + (BYTE * 8)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 8)] = 512 * 114;
		$signal[0xc7 + (BYTE * 8)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 8)] = 512 * 114;
		$signal[0x81 + (BYTE * 8)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 8)] = 512 * 114;
		$signal[0x69 + (BYTE * 8)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 8)] = 512 * 115;
		$signal[0xf0 + (BYTE * 8)] = DEFAULT_SIGNAL;
	}
	
	#112 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 112)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 112)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 112)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 112)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 112)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 112)] = 5;
		}
	}
	
	#113 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 113)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 113)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 113)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 113)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 113)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 113)] = 6;
		}
	}
	
	#114 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 114)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 114)] = 2;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 114)] = 3;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 114)] = 4;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 114)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 114)] = 7;
		}
	}
	
	#115 состояние 2х-байтные опкоды
	{
		foreach(@kk1) {
			$state[$_ + (BYTE * 115)] = 512 * 116;
			$signal[$_ + (BYTE * 115)] = DEFAULT_SIGNAL;
		}
		foreach(@kk2) {
			$state[$_ + (BYTE * 115)] = 512 * 117;
			$signal[$_ + (BYTE * 115)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 115)] = 512 * 118;
		$signal[0x38 + (BYTE * 115)] = DEFAULT_SIGNAL;
	}
	
	#116 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 116)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 116)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 116)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 116)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 116)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 116)] = 5;
		}
	}
	
	#117 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 117)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 117)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 117)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 117)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 117)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 117)] = 6;
		}
	}
	
	#118 состояние 3х-байтные опкоды 38
	{
		foreach(@kkk1) {
			$state[$_ + (BYTE * 118)] = 512 * 119;
			$signal[$_ + (BYTE * 118)] = DEFAULT_SIGNAL;
		}
	}
	
	#119 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 119)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 119)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 119)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 119)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 119)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 119)] = 5;
		}
	}
}

#L
{
	my @l1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @l2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @l3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2,
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @l4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @l5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @ll1 = (0x10..0x12, 0x16, 0x51..0x53,
					0x2a, 0x2c, 0x2d, 0x58..0x5f, 0x6f, 0x7e, 0x7f,
					0xd6, 0xe6,
					0xb8, 0xbc, 0xbd);
	my @ll2 = (0x70, 0xc2);
	my @lll1 = (0xf5, 0xf7);
	#10 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 10)] = 0;
		$signal[0x9a + (BYTE * 10)] = 4;
		$state[0xea + (BYTE * 10)] = 0;
		$signal[0xea + (BYTE * 10)] = 4;
		$state[0xc8 + (BYTE * 10)] = 0;
		$signal[0xc8 + (BYTE * 10)] = 3;
		foreach(@d4) {
			$state[$_ + (BYTE * 10)] = 0;
			$signal[$_ + (BYTE * 10)] = 0;
		}
		foreach(@d3) {
			$state[$_ + (BYTE * 10)] = 0;
			$signal[$_ + (BYTE * 10)] = 2;
		}
		foreach(@d2) {
			$state[$_ + (BYTE * 10)] = 0;
			$signal[$_ + (BYTE * 10)] = 1;
		}
		foreach(@d1) {
			$state[$_ + (BYTE * 10)] = 510 * 120;
			$signal[$_ + (BYTE * 10)] = DEFAULT_SIGNAL;
		}
		foreach(@d5) {
			$state[$_ + (BYTE * 10)] = 510 * 121;
			$signal[$_ + (BYTE * 10)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 10)] = 510 * 122;
		$signal[0xc7 + (BYTE * 10)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 10)] = 510 * 122;
		$signal[0x81 + (BYTE * 10)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 10)] = 510 * 122;
		$signal[0x69 + (BYTE * 10)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 10)] = 510 * 123;
		$signal[0xf0 + (BYTE * 10)] = DEFAULT_SIGNAL;
	}
	
	#120 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 120)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 120)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 120)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 120)] = 2;
		}
	}
	
	#121 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 121)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 121)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 121)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 121)] = 3;
		}
	}
	
	#122 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 122)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 122)] = 2;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 122)] = 3;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 122)] = 4;
		}
	}
	
	#123 состояние 2х-байтные опкоды
	{
		foreach(@ll1) {
			$state[$_ + (BYTE * 123)] = 512 * 124;
			$signal[$_ + (BYTE * 123)] = DEFAULT_SIGNAL;
		}
		foreach(@ll2) {
			$state[$_ + (BYTE * 123)] = 512 * 125;
			$signal[$_ + (BYTE * 123)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 123)] = 512 * 126;
		$signal[0x38 + (BYTE * 123)] = DEFAULT_SIGNAL;
	}
	
	#124 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 124)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 124)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 124)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 124)] = 2;
		}
	}
	
	#125 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 125)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 125)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 125)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 125)] = 3;
		}
	}
	
	#126 состояние 3х-байтные опкоды 38
	{
		foreach(@ddd1) {
			$state[$_ + (BYTE * 126)] = 512 * 127;
			$signal[$_ + (BYTE * 126)] = DEFAULT_SIGNAL;
		}
	}
	
	#127 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 127)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 127)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 127)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 127)] = 2;
		}
	}
}

#M
{
	my @m1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6, 
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @m2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7, 
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @m3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2, 
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @m4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @m5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @mm1 = (0x11..0x17, 0x50, 0x51, 0x54..0x57, 0x60..0x67, 0x74..0x76,
						 0x28..0x2f, 0x58..0x5f, 0x68..0x6f, 0x7c..0x7f,
						 0xc7, 0xd0..0xd7, 0xe0..0xe7, 0xf1..0xf7,
						 0xd8..0xdf, 0xe8..0xef, 0xf8..0xfe);
	my @mm2 = (0x10);
	my @mm3 = (0x70..0x73, 
						0xc2, 
						0xc4..0xc6);
	my @mmm1 = (0x00..0x07, 0x11, 0x13..0x17, 0x20..0x25, 0x30..0x37, 0x40, 0x41, 0x45..0x47, 0x80..0x82, 0x90..0x93, 0x96, 0x97, 0xa6, 0xa7, 0xb6, 0xb7, 0xf0, 0xf1, 0xf3, 0xf7,
							0x08..0x0f, 0x18..0x1a, 0x1c..0x1e, 0x28..0x2f, 0x38..0x3f, 0x58..0x5a, 0x78, 0x79, 0x8c, 0x8e, 0x98..0x9f, 0xa8..0xaf, 0xb8..0xbf, 0xdb..0xdf);
	my @mmm2 = (0x00..0x02, 0x04..0x06, 0x20..0x22, 0x40..0x42, 0x44, 0x46, 0x60..0x63,
							0x08..0x0f, 0x18, 0x19, 0x1d, 0x38, 0x39, 0xdf);
	#1 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 1)] = 0;
		$signal[0x9a + (BYTE * 1)] = 4;
		$state[0xea + (BYTE * 1)] = 0;
		$signal[0xea + (BYTE * 1)] = 4;
		$state[0xc8 + (BYTE * 1)] = 0;
		$signal[0xc8 + (BYTE * 1)] = 3;
		foreach(@m4) {
			$state[$_ + (BYTE * 1)] = 0;
			$signal[$_ + (BYTE * 1)] = 0;
		}
		foreach(@m3) {
			$state[$_ + (BYTE * 1)] = 0;
			$signal[$_ + (BYTE * 1)] = 2;
		}
		foreach(@m2) {
			$state[$_ + (BYTE * 1)] = 0;
			$signal[$_ + (BYTE * 1)] = 1;
		}
		foreach(@m1) {
			$state[$_ + (BYTE * 1)] = 512 * 128;
			$signal[$_ + (BYTE * 1)] = DEFAULT_SIGNAL;
		}
		foreach(@m5) {
			$state[$_ + (BYTE * 1)] = 512 * 129;
			$signal[$_ + (BYTE * 1)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 1)] = 512 * 130;
		$signal[0xc7 + (BYTE * 1)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 1)] = 512 * 130;
		$signal[0x81 + (BYTE * 1)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 1)] = 512 * 130;
		$signal[0x69 + (BYTE * 1)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 1)] = 512 * 131;
		$signal[0xf0 + (BYTE * 1)] = DEFAULT_SIGNAL;
	}
	
	#128 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 128)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 128)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 128)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 128)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 128)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 128)] = 5;
		}
	}
	
	#129 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 129)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 129)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 129)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 129)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 129)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 129)] = 6;
		}
	}
	
	#130 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 130)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 130)] = 2;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 130)] = 3;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 130)] = 4;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 130)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 130)] = 7;
		}
	}
	
	#131 состояние 2х-байтные опкоды
	{
		foreach(@mm2) {
			$state[$_ + (BYTE * 131)] = 0;
			$signal[$_ + (BYTE * 131)] = 0;
		}
		foreach(@mm1) {
			$state[$_ + (BYTE * 131)] = 512 * 132;
			$signal[$_ + (BYTE * 131)] = DEFAULT_SIGNAL;
		}
		foreach(@mm3) {
			$state[$_ + (BYTE * 131)] = 512 * 133;
			$signal[$_ + (BYTE * 131)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 131)] = 512 * 134;
		$signal[0x38 + (BYTE * 131)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 131)] = 512 * 135;
		$signal[0x3a + (BYTE * 131)] = DEFAULT_SIGNAL;
	}
	
	#132 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 132)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 132)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 132)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 132)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 132)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 132)] = 5;
		}
	}
	
	#133 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 133)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 133)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 133)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 133)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 133)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 133)] = 6;
		}
	}
	
	#134 состояние 3х-байтные опкоды 38
	{
		foreach(@mmm1) {
			$state[$_ + (BYTE * 134)] = 512 * 136;
			$signal[$_ + (BYTE * 134)] = DEFAULT_SIGNAL;
		}
	}
	
	#135 состояние 3х-байтные опкоды 3а
	{
		foreach(@mmm2) {
			$state[0x0f + (BYTE * 135)] = 512 * 137;
			$signal[0x0f + (BYTE * 135)] = DEFAULT_SIGNAL;
		}
	}
	
	#136 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 136)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 136)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 136)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 136)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 136)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 136)] = 5;
		}
	}
	
	#137 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 137)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (BYTE * 137)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (BYTE * 137)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (BYTE * 137)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (BYTE * 137)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (BYTE * 137)] = 6;
		}
	}
	
}

#N
{
	my @n1 = (0x00, 0x01, 0x02, 0x03, 0x10, 0x11, 0x12, 0x13, 0x20, 0x21, 0x22, 0x23, 0x30, 0x31, 0x32, 0x33, 0x62, 0x63, 0x84, 0x85, 0x86, 0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6, 
					 0x08, 0x09, 0x0a, 0x0b, 0x18, 0x19, 0x1a, 0x1b, 0x28, 0x29, 0x2a, 0x2b, 0x38, 0x39, 0x3a, 0x3b, 0x88, 0x89, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x8f, 0xfe, 0xff);
	my @n2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7, 
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @n3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3, 0xc2, 
					 0xca, 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @n4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5,
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @n5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @nn1 = (0x11..0x17, 0x50, 0x51, 0x54..0x57, 0x60..0x67, 0x74..0x76,
						 0x28..0x2f, 0x58..0x5f, 0x68..0x6f, 0x7c..0x7f,
						 0xc7, 0xd0..0xd7, 0xe0..0xe7, 0xf1..0xf7,
						 0xd8..0xdf, 0xe8..0xef, 0xf8..0xfe);
	my @nn2 = (0x10);
	my @nn3 = (0x70..0x73, 
						0xc2, 
						0xc4..0xc6);
	my @nnn1 = (0x00..0x07, 0x11, 0x13..0x17, 0x20..0x25, 0x30..0x37, 0x40, 0x41, 0x45..0x47, 0x80..0x82, 0x90..0x93, 0x96, 0x97, 0xa6, 0xa7, 0xb6, 0xb7, 0xf0, 0xf1, 0xf3, 0xf7,
							0x08..0x0f, 0x18..0x1a, 0x1c..0x1e, 0x28..0x2f, 0x38..0x3f, 0x58..0x5a, 0x78, 0x79, 0x8c, 0x8e, 0x98..0x9f, 0xa8..0xaf, 0xb8..0xbf, 0xdb..0xdf);
	my @nnn2 = (0x00..0x02, 0x04..0x06, 0x20..0x22, 0x40..0x42, 0x44, 0x46, 0x60..0x63,
							0x08..0x0f, 0x18, 0x19, 0x1d, 0x38, 0x39, 0xdf);
	#2 состояние 1-байтные опкоды
	{
		$state[0x9a + (BYTE * 2)] = 0;
		$signal[0x9a + (BYTE * 2)] = 4;
		$state[0xea + (BYTE * 2)] = 0;
		$signal[0xea + (BYTE * 2)] = 4;
		$state[0xc8 + (BYTE * 2)] = 0;
		$signal[0xc8 + (BYTE * 2)] = 3;
		foreach(@n4) {
			$state[$_ + (BYTE * 2)] = 0;
			$signal[$_ + (BYTE * 2)] = 0;
		}
		foreach(@n3) {
			$state[$_ + (BYTE * 2)] = 0;
			$signal[$_ + (BYTE * 2)] = 2;
		}
		foreach(@n2) {
			$state[$_ + (BYTE * 2)] = 0;
			$signal[$_ + (BYTE * 2)] = 1;
		}
		foreach(@n1) {
			$state[$_ + (BYTE * 2)] = 512 * 138;
			$signal[$_ + (BYTE * 2)] = DEFAULT_SIGNAL;
		}
		foreach(@n5) {
			$state[$_ + (BYTE * 2)] = 512 * 139;
			$signal[$_ + (BYTE * 2)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (BYTE * 2)] = 512 * 140;
		$signal[0xc7 + (BYTE * 2)] = DEFAULT_SIGNAL;
		$state[0x81 + (BYTE * 2)] = 512 * 140;
		$signal[0x81 + (BYTE * 2)] = DEFAULT_SIGNAL;
		$state[0x69 + (BYTE * 2)] = 512 * 140;
		$signal[0x69 + (BYTE * 2)] = DEFAULT_SIGNAL;
		$state[0xf0 + (BYTE * 2)] = 512 * 141;
		$signal[0xf0 + (BYTE * 2)] = DEFAULT_SIGNAL;
	}
	
	#138 состояние modrm_16
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 138)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 138)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 138)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 138)] = 2;
		}
	}
	
	#139 состояние modrm_16 + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 139)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 139)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 139)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 139)] = 3;
		}
	}
	
	#140 состояние modrm_16 + 2
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 140)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 140)] = 2;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 140)] = 3;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 140)] = 4;
		}
	}
	
	#141 состояние 2х-байтные опкоды
	{
		foreach(@nn2) {
			$state[$_ + (BYTE * 141)] = 0;
			$signal[$_ + (BYTE * 141)] = 0;
		}
		foreach(@nn1) {
			$state[$_ + (BYTE * 141)] = 512 * 142;
			$signal[$_ + (BYTE * 141)] = DEFAULT_SIGNAL;
		}
		foreach(@nn3) {
			$state[$_ + (BYTE * 141)] = 512 * 143;
			$signal[$_ + (BYTE * 141)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (BYTE * 141)] = 512 * 144;
		$signal[0x38 + (BYTE * 141)] = DEFAULT_SIGNAL;
		$state[0x3a + (BYTE * 141)] = 512 * 145;
		$signal[0x3a + (BYTE * 141)] = DEFAULT_SIGNAL;
	}
	
	#142 состояние modrm_16
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 142)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 142)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 142)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 142)] = 2;
		}
	}
	
	#143 состояние modrm_16 + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 143)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 143)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 143)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 143)] = 3;
		}
	}
	
	#144 состояние 3х-байтные опкоды 38
	{
		foreach(@nnn1) {
			$state[$_ + (BYTE * 144)] = 512 * 146;
			$signal[$_ + (BYTE * 144)] = DEFAULT_SIGNAL;
		}
	}
	
	#145 состояние 3х-байтные опкоды 3а
	{
		foreach(@nnn2) {
			$state[0x0f + (BYTE * 145)] = 512 * 147;
			$signal[0x0f + (BYTE * 145)] = DEFAULT_SIGNAL;
		}
	}
	
	#146 состояние modrm_16
	{
		for(0..0xff) {
			$state[$_ + (BYTE * 146)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 146)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 146)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 146)] = 2;
		}
	}
	
	#147 состояние modrm_16 + 1
	{
		for(0..0xff) {
			$state[$_+ (BYTE * 147)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (BYTE * 147)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (BYTE * 147)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (BYTE * 147)] = 3;
		}
	}
	
}

print $outputState "opcodeState";
print $outputSignal "opcodeSignal";
#вложенные foreach, мрак и ужас
	my $max = 0;
foreach(@state) {
	if($_ > $max) {$max = $_;}
	print $outputState " dw $_ \n";
}
foreach(@signal) {
	if($_ > $max) {$max = $_;}
	print $outputSignal " db $_ \n";
}

close $outputState;
close $outputSignal;