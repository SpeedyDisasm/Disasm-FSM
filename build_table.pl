use 5.016;
#use warnings;
#use diagnostics;
use constant DEFAULT_SIGNAL => 16;

#push my @state, [&getClearState];
#push my @signal, [&getClearState];

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
#A
{
	my @a1 = (0x00..0x03, 0x10..0x13, 0x20..0x23, 0x30..0x33, 0x62, 0x63, 0x84..0x87, 0xc4, 0xc5, 0xd0..0xd3, 0xf7, 0xf6,
					 0x08..0x0b, 0x18..0x1b, 0x28..0x2b, 0x38..0x3b, 0x88..0x8f, 0xfe, 0xff);
	my @a2 = (0x04, 0x14, 0x24, 0x34, 0xa0, 0xa2, 0xb0..0xb7, 0xd4, 0xd5, 0xe0..0xe7,
					 0x0c, 0x1c, 0x2c, 0x3c, 0x6a, 0xa8, 0xcd, 0xeb);
	my @a3 = (0x05, 0x15, 0x25, 0x35, 0xa1, 0xa3,
					 0x0d, 0x1d, 0x2d, 0x3d, 0x68, 0xa9, 0xb8..0xbf, 0xe8, 0xe9);
	my @a4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5
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
		$state[0x9a + (256 * 15)] = 0;
		$signal[0x9a + (256 * 15)] = 6;
		$state[0xea + (256 * 15)] = 0;
		$signal[0xea + (256 * 15)] = 6;
		$state[0xc8 + (256 * 15)] = 0;
		$signal[0xc8 + (256 * 15)] = 3;
		$state[0xc2 + (256 * 15)] = 0;
		$signal[0xc2 + (256 * 15)] = 2;
		$state[0xca + (256 * 15)] = 0;
		$signal[0xca + (256 * 15)] = 2;
		foreach(@a4) {
			$state[$_ + (256 * 15)] = 0;
			$signal[$_ + (256 * 15)] = 0;
		}
		foreach(@a3) {
			$state[$_ + (256 * 15)] = 0;
			$signal[$_ + (256 * 15)] = 4;
		}
		foreach(@a2) {
			$state[$_ + (256 * 15)] = 0;
			$signal[$_ + (256 * 15)] = 1;
		}
		foreach(@a1) {
			$state[$_ + (256 * 15)] = 16;
			$signal[$_ + (256 * 15)] = DEFAULT_SIGNAL;
		}
		foreach(@a5) {
			$state[$_ + (256 * 15)] = 17;
			$signal[$_ + (256 * 15)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 15)] = 18;
		$signal[0xc7 + (256 * 15)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 15)] = 18;
		$signal[0x81 + (256 * 15)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 15)] = 18;
		$signal[0x69 + (256 * 15)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 15)] = 19;
		$signal[0xf0 + (256 * 15)] = DEFAULT_SIGNAL;
	}
	
	#16 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 16)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 16)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 16)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 16)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 16)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 16)] = 5;
		}
	}
	
	#17 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 17)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 17)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 17)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 17)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 17)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 17)] = 6;
		}
	}
	
	#18 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (256 * 18)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 18)] = 4;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 18)] = 5;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 18)] = 6;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 18)] = 8;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 18)] = 9;
		}
	}
	
	#19 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (256 * 19)] = 0;
			$signal[$_ + (256 * 19)] = 4;
		}
		foreach(@aa2) {
			$state[$_ + (256 * 19)] = 0;
			$signal[$_ + (256 * 19)] = 0;
		}
		foreach(@aa1) {
			$state[$_ + (256 * 19)] = 20;
			$signal[$_ + (256 * 19)] = DEFAULT_SIGNAL;
		}
		foreach(@aa3) {
			$state[$_ + (256 * 19)] = 21;
			$signal[$_ + (256 * 19)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 19)] = 22;
		$signal[0x38 + (256 * 19)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 19)] = 23;
		$signal[0x3a + (256 * 19)] = DEFAULT_SIGNAL;
	}
	
	#20 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 20)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 20)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 20)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 20)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 20)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 20)] = 5;
		}
	}
	
	#21 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 21)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 21)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 21)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 21)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 21)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 21)] = 6;
		}
	}
	
	#22 состояние 3х-байтные опкоды 38
	{
		foreach(@aaa1) {
			$state[$_ + (256 * 22)] = 24;
			$signal[$_ + (256 * 22)] = DEFAULT_SIGNAL;
		}
	}
	
	#23 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 23)] = 25;
		$signal[0x0f + (256 * 23)] = DEFAULT_SIGNAL;
	}
	
	#24 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 24)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 24)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 24)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 24)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 24)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 24)] = 5;
		}
	}
	
	#25 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 25)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 25)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 25)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 25)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 25)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 25)] = 6;
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
		$state[0x9a + (256 * 14)] = 0;
		$signal[0x9a + (256 * 14)] = 4;
		$state[0xea + (256 * 14)] = 0;
		$signal[0xea + (256 * 14)] = 4;
		$state[0xc8 + (256 * 14)] = 0;
		$signal[0xc8 + (256 * 14)] = 3;
		foreach(@b4) {
			$state[$_ + (256 * 14)] = 0;
			$signal[$_ + (256 * 14)] = 0;
		}
		foreach(@b3) {
			$state[$_ + (256 * 14)] = 0;
			$signal[$_ + (256 * 14)] = 2;
		}
		foreach(@b2) {
			$state[$_ + (256 * 14)] = 0;
			$signal[$_ + (256 * 14)] = 1;
		}
		foreach(@b1) {
			$state[$_ + (256 * 14)] = 26;
			$signal[$_ + (256 * 14)] = DEFAULT_SIGNAL;
		}
		foreach(@b5) {
			$state[$_ + (256 * 14)] = 27;
			$signal[$_ + (256 * 14)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 14)] = 28;
		$signal[0xc7 + (256 * 14)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 14)] = 28;
		$signal[0x81 + (256 * 14)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 14)] = 28;
		$signal[0x69 + (256 * 14)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 14)] = 29;
		$signal[0xf0 + (256 * 14)] = DEFAULT_SIGNAL;
	}
	
	#26 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 26)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 26)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 26)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 26)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 26)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 26)] = 5;
		}
	}
	
	#27 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 27)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 27)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 27)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 27)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 27)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 27)] = 6;
		}
	}
	
	#28 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (256 * 28)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 28)] = 2;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 28)] = 3;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 28)] = 4;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 28)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 28)] = 7;
		}
	}
	
	#29 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (256 * 29)] = 0;
			$signal[$_ + (256 * 29)] = 2;
		}
		foreach(@bb2) {
			$state[$_ + (256 * 29)] = 0;
			$signal[$_ + (256 * 29)] = 0;
		}
		foreach(@bb1) {
			$state[$_ + (256 * 29)] = 30;
			$signal[$_ + (256 * 29)] = DEFAULT_SIGNAL;
		}
		foreach(@bb3) {
			$state[$_ + (256 * 29)] = 31;
			$signal[$_ + (256 * 29)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 29)] = 32;
		$signal[0x38 + (256 * 29)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 29)] = 33;
		$signal[0x3a + (256 * 29)] = DEFAULT_SIGNAL;
	}
	
	#30 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 30)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 30)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 30)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 30)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 30)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 30)] = 5;
		}
	}
	
	#31 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 31)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 31)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 31)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 31)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 31)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 31)] = 6;
		}
	}
	
	#32 состояние 3х-байтные опкоды 38
	{
		foreach(@bbb1) {
			$state[$_ + (256 * 32)] = 34;
			$signal[$_ + (256 * 32)] = DEFAULT_SIGNAL;
		}
	}
	
	#33 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 33)] = 35;
		$signal[0x0f + (256 * 33)] = DEFAULT_SIGNAL;
	}
	
	#34 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 34)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 34)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 34)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 34)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 34)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 34)] = 5;
		}
	}
	
	#35 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (356 * 35)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (356 * 35)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (356 * 35)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (356 * 35)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (356 * 35)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (356 * 35)] = 6;
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
	my @c4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5
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
		$state[0x9a + (256 * 11)] = 0;
		$signal[0x9a + (256 * 11)] = 6;
		$state[0xea + (256 * 11)] = 0;
		$signal[0xea + (256 * 11)] = 6;
		$state[0xc8 + (256 * 11)] = 0;
		$signal[0xc8 + (256 * 11)] = 3;
		$state[0xc2 + (256 * 11)] = 0;
		$signal[0xc2 + (256 * 11)] = 2;
		$state[0xca + (256 * 11)] = 0;
		$signal[0xca + (256 * 11)] = 2;
		foreach(@c4) {
			$state[$_ + (256 * 11)] = 0;
			$signal[$_ + (256 * 11)] = 0;
		}
		foreach(@c3) {
			$state[$_ + (256 * 11)] = 0;
			$signal[$_ + (256 * 11)] = 4;
		}
		foreach(@c2) {
			$state[$_ + (256 * 11)] = 0;
			$signal[$_ + (256 * 11)] = 1;
		}
		foreach(@c1) {
			$state[$_ + (256 * 11)] = 36;
			$signal[$_ + (256 * 11)] = DEFAULT_SIGNAL;
		}
		foreach(@c5) {
			$state[$_ + (256 * 11)] = 37;
			$signal[$_ + (256 * 11)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 11)] = 38;
		$signal[0xc7 + (256 * 11)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 11)] = 38;
		$signal[0x81 + (256 * 11)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 11)] = 38;
		$signal[0x69 + (256 * 11)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 11)] = 39;
		$signal[0xf0 + (256 * 11)] = DEFAULT_SIGNAL;
	}
	
	#36 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 36)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 36)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 36)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 36)] = 2;
		}
	}
	
	#37 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 37)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 37)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 37)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 37)] = 3;
		}
	}
	
	#38 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (256 * 38)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 38)] = 4;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 38)] = 5;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 38)] = 6;
		}
	}
	
	#39 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (256 * 39)] = 0;
			$signal[$_ + (256 * 39)] = 4;
		}
		foreach(@cc2) {
			$state[$_ + (256 * 39)] = 0;
			$signal[$_ + (256 * 39)] = 0;
		}
		foreach(@cc1) {
			$state[$_ + (256 * 39)] = 40;
			$signal[$_ + (256 * 39)] = DEFAULT_SIGNAL;
		}
		foreach(@cc3) {
			$state[$_ + (256 * 39)] = 41;
			$signal[$_ + (256 * 39)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 39)] = 42;
		$signal[0x38 + (256 * 39)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 39)] = 43;
		$signal[0x3a + (256 * 39)] = DEFAULT_SIGNAL;
	}
	
	#40 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 40)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 40)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 40)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 40)] = 2;
		}
	}
	
	#41 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 41)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 41)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 41)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 41)] = 3;
		}
	}
	
	#42 состояние 3х-байтные опкоды 38
	{
		foreach(@ccc1) {
			$state[$_ + (256 * 42)] = 44;
			$signal[$_ + (256 * 42)] = DEFAULT_SIGNAL;
		}
	}
	
	#43 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 43)] = 45;
		$signal[0x0f + (256 * 43)] = DEFAULT_SIGNAL;
	}
	
	#44 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 44)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 44)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 44)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 44)] = 2;
		}
	}
	
	#45 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 45)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 45)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 45)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 45)] = 3;
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
		$state[0x9a + (256 * 12)] = 0;
		$signal[0x9a + (256 * 12)] = 4;
		$state[0xea + (256 * 12)] = 0;
		$signal[0xea + (256 * 12)] = 4;
		$state[0xc8 + (256 * 12)] = 0;
		$signal[0xc8 + (256 * 12)] = 3;
		foreach(@d4) {
			$state[$_ + (256 * 12)] = 0;
			$signal[$_ + (256 * 12)] = 0;
		}
		foreach(@d3) {
			$state[$_ + (256 * 12)] = 0;
			$signal[$_ + (256 * 12)] = 2;
		}
		foreach(@d2) {
			$state[$_ + (256 * 12)] = 0;
			$signal[$_ + (256 * 12)] = 1;
		}
		foreach(@d1) {
			$state[$_ + (256 * 12)] = 46;
			$signal[$_ + (256 * 12)] = DEFAULT_SIGNAL;
		}
		foreach(@d5) {
			$state[$_ + (256 * 12)] = 47;
			$signal[$_ + (256 * 12)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 12)] = 48;
		$signal[0xc7 + (256 * 12)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 12)] = 48;
		$signal[0x81 + (256 * 12)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 12)] = 48;
		$signal[0x69 + (256 * 12)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 12)] = 49;
		$signal[0xf0 + (256 * 12)] = DEFAULT_SIGNAL;
	}
	
	#46 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 46)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 46)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 46)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 46)] = 2;
		}
	}
	
	#47 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 47)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 47)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 47)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 47)] = 3;
		}
	}
	
	#48 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (256 * 48)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 48)] = 2;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 48)] = 3;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 48)] = 4;
		}
	}
	
	#49 состояние 2х-байтные опкоды
	{
		for(0x80..0x8f) {
			$state[$_ + (256 * 49)] = 0;
			$signal[$_ + (256 * 49)] = 2;
		}
		foreach(@dd2) {
			$state[$_ + (256 * 29)] = 0;
			$signal[$_ + (256 * 29)] = 0;
		}
		foreach(@dd1) {
			$state[$_ + (256 * 29)] = 50;
			$signal[$_ + (256 * 29)] = DEFAULT_SIGNAL;
		}
		foreach(@dd3) {
			$state[$_ + (256 * 29)] = 51;
			$signal[$_ + (256 * 29)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 29)] = 52;
		$signal[0x38 + (256 * 29)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 29)] = 53;
		$signal[0x3a + (256 * 29)] = DEFAULT_SIGNAL;
	}
	
	#50 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 50)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 50)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 50)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 50)] = 2;
		}
	}
	
	#51 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 51)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 51)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 51)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 51)] = 3;
		}
	}
	
	#52 состояние 3х-байтные опкоды 38
	{
		foreach(@ddd1) {
			$state[$_ + (256 * 52)] = 54;
			$signal[$_ + (256 * 52)] = DEFAULT_SIGNAL;
		}
	}
	
	#53 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 53)] = 55;
		$signal[0x0f + (256 * 53)] = DEFAULT_SIGNAL;
	}
	
	#54 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 54)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 54)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 54)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 54)] = 2;
		}
	}
	
	#55 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (356 * 55)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (356 * 55)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (356 * 55)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (356 * 55)] = 3;
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
		$state[0x9a + (256 * 3)] = 0;
		$signal[0x9a + (256 * 3)] = 6;
		$state[0xea + (256 * 3)] = 0;
		$signal[0xea + (256 * 3)] = 6;
		$state[0xc8 + (256 * 3)] = 0;
		$signal[0xc8 + (256 * 3)] = 3;
		$state[0xc2 + (256 * 3)] = 0;
		$signal[0xc2 + (256 * 3)] = 2;
		$state[0xca + (256 * 3)] = 0;
		$signal[0xca + (256 * 3)] = 2;
		foreach(@e4) {
			$state[$_ + (256 * 3)] = 0;
			$signal[$_ + (256 * 3)] = 0;
		}
		foreach(@e3) {
			$state[$_ + (256 * 3)] = 0;
			$signal[$_ + (256 * 3)] = 4;
		}
		foreach(@e2) {
			$state[$_ + (256 * 3)] = 0;
			$signal[$_ + (256 * 3)] = 1;
		}
		foreach(@e1) {
			$state[$_ + (256 * 3)] = 56;
			$signal[$_ + (256 * 3)] = DEFAULT_SIGNAL;
		}
		foreach(@e5) {
			$state[$_ + (256 * 3)] = 57;
			$signal[$_ + (256 * 3)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 3)] = 58;
		$signal[0xc7 + (256 * 3)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 3)] = 58;
		$signal[0x81 + (256 * 3)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 3)] = 58;
		$signal[0x69 + (256 * 3)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 3)] = 59;
		$signal[0xf0 + (256 * 3)] = DEFAULT_SIGNAL;
	}
	
	#56 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 56)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 56)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 56)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 56)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 56)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 56)] = 5;
		}
	}
	
	#57 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 57)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 57)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 57)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 57)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 57)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 57)] = 6;
		}
	}
	
	#58 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (256 * 58)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 58)] = 4;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 58)] = 5;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 58)] = 6;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 58)] = 8;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 58)] = 9;
		}
	}
	
	#59 состояние 2х-байтные опкоды
	{
		foreach(@ee1) {
			$state[$_ + (256 * 59)] = 60;
			$signal[$_ + (256 * 59)] = DEFAULT_SIGNAL;
		}
		foreach(@ee2) {
			$state[$_ + (256 * 59)] = 61;
			$signal[$_ + (256 * 59)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 59)] = 62;
		$signal[0x38 + (256 * 59)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 59)] = 63;
		$signal[0x3a + (256 * 59)] = DEFAULT_SIGNAL;
	}
	
	#60 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 60)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 60)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 60)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 60)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 60)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 60)] = 5;
		}
	}
	
	#61 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 61)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 61)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 61)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 61)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 61)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 61)] = 6;
		}
	}
	
	#62 состояние 3х-байтные опкоды 38
	{
		foreach(@aaa1) {
			$state[$_ + (256 * 62)] = 64;
			$signal[$_ + (256 * 22)] = DEFAULT_SIGNAL;
		}
	}
	
	#63 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 63)] = 65;
		$signal[0x0f + (256 * 63)] = DEFAULT_SIGNAL;
	}
	
	#64 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 64)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 64)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 64)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 64)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 64)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 64)] = 5;
		}
	}
	
	#65 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 65)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 65)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 65)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 65)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 65)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 65)] = 6;
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
	my @f4 = (0x06, 0x07, 0x16, 0x17, 0x27, 0x37, 0x40..0x47, 0x50..0x57, 0x60, 0x61, 0x70..0x77, 0x90..0x97, 0xa4..0xa7, 0xc3, 0xd7, 0xf4, 0xf5
					 0x0e, 0x1e, 0x1f, 0x2f, 0x3f, 0x48..0x4f, 0x58..0x5f, 0x6c..0x6f, 0x78..0x7f, 0x98, 0x99, 0x9b..0x9f, 0xaa..0xaf, 0xc9, 0xcb, 0xcc, 0xce, 0xcf, 0xec..0xef, 0xf8..0xfd);
	my @f5 = (0x80, 0x82, 0x83, 0xc0, 0xc1, 0xc6, 0x6b);
	my @ff1 = (0x10..0x12, 0x51,
					 0x2a, 0x2c, 0x2d, 0x58..0x5a, 0x5c..0x5f, 0x7c, 0x7d,
					 0xd0, 0xd6, 0xe6, 0xf0);
	my @ff2 = (0x70, 0xc2);
	my @fff1 = (0xf0, 0xf1);
	#5 состояние 1-байтные опкоды
	{
		$state[0x9a + (256 * 5)] = 0;
		$signal[0x9a + (256 * 5)] = 6;
		$state[0xea + (256 * 5)] = 0;
		$signal[0xea + (256 * 5)] = 6;
		$state[0xc8 + (256 * 5)] = 0;
		$signal[0xc8 + (256 * 5)] = 3;
		$state[0xc2 + (256 * 5)] = 0;
		$signal[0xc2 + (256 * 5)] = 2;
		$state[0xca + (256 * 5)] = 0;
		$signal[0xca + (256 * 5)] = 2;
		foreach(@f4) {
			$state[$_ + (256 * 5)] = 0;
			$signal[$_ + (256 * 5)] = 0;
		}
		foreach(@f3) {
			$state[$_ + (256 * 5)] = 0;
			$signal[$_ + (256 * 5)] = 4;
		}
		foreach(@f2) {
			$state[$_ + (256 * 5)] = 0;
			$signal[$_ + (256 * 5)] = 1;
		}
		foreach(@f1) {
			$state[$_ + (256 * 5)] = 66;
			$signal[$_ + (256 * 5)] = DEFAULT_SIGNAL;
		}
		foreach(@f5) {
			$state[$_ + (256 * 5)] = 67;
			$signal[$_ + (256 * 5)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 5)] = 68;
		$signal[0xc7 + (256 * 5)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 5)] = 68;
		$signal[0x81 + (256 * 5)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 5)] = 68;
		$signal[0x69 + (256 * 5)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 5)] = 69;
		$signal[0xf0 + (256 * 5)] = DEFAULT_SIGNAL;
	}
	
	#66 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 66)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 66)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 66)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 66)] = 2;
		}
	}
	
	#67 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 67)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 67)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 67)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 67)] = 3;
		}
	}
	
	#68 состояние modRM + 4
	{
		for(0..0xff) {
			$state[$_+ (256 * 68)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 68)] = 4;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 68)] = 5;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 68)] = 6;
		}
	}
	
	#69 состояние 2х-байтные опкоды
	{
		foreach(@ff1) {
			$state[$_ + (256 * 69)] = 70;
			$signal[$_ + (256 * 69)] = DEFAULT_SIGNAL;
		}
		foreach(@ff2) {
			$state[$_ + (256 * 69)] = 71;
			$signal[$_ + (256 * 69)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 69)] = 72;
		$signal[0x38 + (256 * 69)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 69)] = 73;
		$signal[0x3a + (256 * 69)] = DEFAULT_SIGNAL;
	}
	
	#70 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 70)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 70)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 70)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 70)] = 2;
		}
	}
	
	#71 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 71)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 71)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 71)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 71)] = 3;
		}
	}
	
	#72 состояние 3х-байтные опкоды 38
	{
		foreach(@fff1) {
			$state[$_ + (256 * 72)] = 74;
			$signal[$_ + (256 * 72)] = DEFAULT_SIGNAL;
		}
	}
	
	#73 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 73)] = 75;
		$signal[0x0f + (256 * 73)] = DEFAULT_SIGNAL;
	}
	
	#74 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 74)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 74)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 74)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 74)] = 2;
		}
	}
	
	#75 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 75)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 75)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 75)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 75)] = 3;
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
		$state[0x9a + (256 * 4)] = 0;
		$signal[0x9a + (256 * 4)] = 4;
		$state[0xea + (256 * 4)] = 0;
		$signal[0xea + (256 * 4)] = 4;
		$state[0xc8 + (256 * 4)] = 0;
		$signal[0xc8 + (256 * 4)] = 3;
		foreach(@g4) {
			$state[$_ + (256 * 4)] = 0;
			$signal[$_ + (256 * 4)] = 0;
		}
		foreach(@g3) {
			$state[$_ + (256 * 4)] = 0;
			$signal[$_ + (256 * 4)] = 2;
		}
		foreach(@g2) {
			$state[$_ + (256 * 4)] = 0;
			$signal[$_ + (256 * 4)] = 1;
		}
		foreach(@g1) {
			$state[$_ + (256 * 4)] = 76;
			$signal[$_ + (256 * 4)] = DEFAULT_SIGNAL;
		}
		foreach(@g5) {
			$state[$_ + (256 * 4)] = 77;
			$signal[$_ + (256 * 4)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 4)] = 78;
		$signal[0xc7 + (256 * 4)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 4)] = 78;
		$signal[0x81 + (256 * 4)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 4)] = 78;
		$signal[0x69 + (256 * 4)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 4)] = 79;
		$signal[0xf0 + (256 * 4)] = DEFAULT_SIGNAL;
	}
	
	#76 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 76)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 76)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 76)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 76)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 76)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 76)] = 5;
		}
	}
	
	#77 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 77)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 77)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 77)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 77)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 77)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 77)] = 6;
		}
	}
	
	#78 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (256 * 78)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 78)] = 2;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 78)] = 3;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 78)] = 4;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 78)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 78)] = 7;
		}
	}
	
	#79 состояние 2х-байтные опкоды
	{
		foreach(@gg1) {
			$state[$_ + (256 * 79)] = 80;
			$signal[$_ + (256 * 79)] = DEFAULT_SIGNAL;
		}
		foreach(@gg2) {
			$state[$_ + (256 * 79)] = 81;
			$signal[$_ + (256 * 79)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 79)] = 82;
		$signal[0x38 + (256 * 79)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 79)] = 83;
		$signal[0x3a + (256 * 79)] = DEFAULT_SIGNAL;
	}
	
	#80 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 80)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 80)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 80)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 80)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 80)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 80)] = 5;
		}
	}
	
	#81 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 81)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 81)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 81)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 81)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 81)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 81)] = 6;
		}
	}
	
	#82 состояние 3х-байтные опкоды 38
	{
		foreach(@ggg1) {
			$state[$_ + (256 * 82)] = 84;
			$signal[$_ + (256 * 82)] = DEFAULT_SIGNAL;
		}
	}
	
	#83 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 83)] = 85;
		$signal[0x0f + (256 * 83)] = DEFAULT_SIGNAL;
	}
	
	#84 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 84)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (256 * 84)] = 0;
		}
		foreach(@modrm_1) {
			$signal[$_+ (256 * 84)] = 1;
		}
		foreach(@modrm_2) {
			$signal[$_+ (256 * 84)] = 2;
		}
		foreach(@modrm_4) {
			$signal[$_+ (256 * 84)] = 4;
		}
		foreach(@modrm_5) {
			$signal[$_+ (256 * 84)] = 5;
		}
	}
	
	#85 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (856 * 85)] = 0;
		}
		foreach(@modrm_0) {
			$signal[$_+ (856 * 85)] = 1;
		}
		foreach(@modrm_1) {
			$signal[$_+ (856 * 85)] = 2;
		}
		foreach(@modrm_2) {
			$signal[$_+ (856 * 85)] = 3;
		}
		foreach(@modrm_4) {
			$signal[$_+ (856 * 85)] = 5;
		}
		foreach(@modrm_5) {
			$signal[$_+ (856 * 85)] = 6;
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
		$state[0x9a + (256 * 6)] = 0;
		$signal[0x9a + (256 * 6)] = 4;
		$state[0xea + (256 * 6)] = 0;
		$signal[0xea + (256 * 6)] = 4;
		$state[0xc8 + (256 * 6)] = 0;
		$signal[0xc8 + (256 * 6)] = 3;
		foreach(@d4) {
			$state[$_ + (256 * 6)] = 0;
			$signal[$_ + (256 * 6)] = 0;
		}
		foreach(@d3) {
			$state[$_ + (256 * 6)] = 0;
			$signal[$_ + (256 * 6)] = 2;
		}
		foreach(@d2) {
			$state[$_ + (256 * 6)] = 0;
			$signal[$_ + (256 * 6)] = 1;
		}
		foreach(@d1) {
			$state[$_ + (256 * 6)] = 86;
			$signal[$_ + (256 * 6)] = DEFAULT_SIGNAL;
		}
		foreach(@d5) {
			$state[$_ + (256 * 6)] = 87;
			$signal[$_ + (256 * 6)] = DEFAULT_SIGNAL;
		}
		$state[0xc7 + (256 * 6)] = 88;
		$signal[0xc7 + (256 * 6)] = DEFAULT_SIGNAL;
		$state[0x81 + (256 * 6)] = 88;
		$signal[0x81 + (256 * 6)] = DEFAULT_SIGNAL;
		$state[0x69 + (256 * 6)] = 88;
		$signal[0x69 + (256 * 6)] = DEFAULT_SIGNAL;
		$state[0xf0 + (256 * 6)] = 89;
		$signal[0xf0 + (256 * 6)] = DEFAULT_SIGNAL;
	}
	
	#86 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 86)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 86)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 86)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 86)] = 2;
		}
	}
	
	#87 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 87)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 87)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 87)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 87)] = 3;
		}
	}
	
	#88 состояние modRM + 2
	{
		for(0..0xff) {
			$state[$_+ (256 * 88)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 88)] = 2;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 88)] = 3;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 88)] = 4;
		}
	}
	
	#89 состояние 2х-байтные опкоды
	{
		foreach(@dd1) {
			$state[$_ + (256 * 29)] = 90;
			$signal[$_ + (256 * 29)] = DEFAULT_SIGNAL;
		}
		foreach(@dd2) {
			$state[$_ + (256 * 29)] = 91;
			$signal[$_ + (256 * 29)] = DEFAULT_SIGNAL;
		}
		$state[0x38 + (256 * 29)] = 92;
		$signal[0x38 + (256 * 29)] = DEFAULT_SIGNAL;
		$state[0x3a + (256 * 29)] = 93;
		$signal[0x3a + (256 * 29)] = DEFAULT_SIGNAL;
	}
	
	#90 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 90)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 90)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 90)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 90)] = 2;
		}
	}
	
	#91 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (256 * 91)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 91)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 91)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 91)] = 3;
		}
	}
	
	#92 состояние 3х-байтные опкоды 38
	{
		foreach(@ddd1) {
			$state[$_ + (256 * 92)] = 94;
			$signal[$_ + (256 * 92)] = DEFAULT_SIGNAL;
		}
	}
	
	#93 состояние 3х-байтные опкоды 3а
	{
		$state[0x0f + (256 * 93)] = 95;
		$signal[0x0f + (256 * 93)] = DEFAULT_SIGNAL;
	}
	
	#94 состояние modRM
	{
		for(0..0xff) {
			$state[$_ + (256 * 94)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (256 * 94)] = 0;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (256 * 94)] = 1;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (256 * 94)] = 2;
		}
	}
	
	#95 состояние modRM + 1
	{
		for(0..0xff) {
			$state[$_+ (356 * 95)] = 0;
		}
		foreach(@modrm_16_0) {
			$signal[$_+ (356 * 95)] = 1;
		}
		foreach(@modrm_16_1) {
			$signal[$_+ (356 * 95)] = 2;
		}
		foreach(@modrm_16_2) {
			$signal[$_+ (356 * 95)] = 3;
		}
	}
	
}

print $outputState "opcodeState";
#вложенные foreach, мрак и ужас
	my $max = 0;
foreach(@stateTable) {
	foreach(@$_) {
		if($_ > $max) {$max = $_;}
		print $outputState " dw $_ \n";
		}
}
foreach(@signalTable) {
	foreach(@$_) {
		if($_ > $max) {$max = $_;}
		print $outputSignal " dw $_ \n";
		}
}

close $in;
close $outputState;
close $outputSignal;