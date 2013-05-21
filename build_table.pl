use 5.016;
#use warnings;
#use diagnostics;
use constant DEFAULT_SIGNAL => 16;
use constant BYTE => 256;

#push my @state, [&getClearState];
#push my @signal, [&getClearState];
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
for(0..0xff*95) {
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