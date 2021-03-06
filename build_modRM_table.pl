use 5.016;
use warnings;
use diagnostics;

open my $out, ">", "modRM_state_table.dat" or die "wtf";

my @stateModRM = ();
for(0..256*6) { push @stateModRM, 0}
#��, � ������� ��� ��� ����� ���� ������� �������������, � �� �������. �� ��� ���������.
my @state1_16 = (0x40, 0x48, 0x50, 0x58, 0x60, 0x68, 0x70, 0x78,
							0x41, 0x49, 0x51, 0x59, 0x61, 0x69, 0x71, 0x79,
							0x42, 0x4a, 0x52, 0x5a, 0x62, 0x6a, 0x72, 0x7a,
							0x43, 0x4b, 0x53, 0x5b, 0x63, 0x6b, 0x73, 0x7b,
							0x44, 0x4c, 0x54, 0x5c, 0x64, 0x6c, 0x74, 0x7c,
							0x45, 0x4d, 0x55, 0x5d, 0x65, 0x6d, 0x75, 0x7d,
							0x46, 0x4e, 0x56, 0x5e, 0x66, 0x6e, 0x76, 0x7e,
							0x47, 0x4f, 0x57, 0x5f, 0x67, 0x6f, 0x77, 0x7f);
							
my @state2_16 = (0x06, 0x0e, 0x16, 0x1e, 0x26, 0x2e, 0x36, 0x3e,
							0x81, 0x89, 0x91, 0x99, 0xa1, 0xa9, 0xb1, 0xb9,
							0x82, 0x8a, 0x92, 0x9a, 0xa2, 0xaa, 0xb2, 0xba,
							0x83, 0x8b, 0x93, 0x9b, 0xa3, 0xab, 0xb3, 0xbb,
							0x84, 0x8c, 0x94, 0x9c, 0xa4, 0xac, 0xb4, 0xbc,
							0x85, 0x8d, 0x95, 0x9d, 0xa5, 0xad, 0xb5, 0xbd,
							0x86, 0x8e, 0x96, 0x9e, 0xa6, 0xae, 0xb6, 0xbe,
							0x87, 0x8f, 0x97, 0x9f, 0xa7, 0xaf, 0xb7, 0xbf);
							
my @state1_32 = (0x04, 0x0c, 0x14, 0x1c, 0x24, 0x2c, 0x34, 0x3c,
							0x40, 0x48, 0x50, 0x58, 0x60, 0x68, 0x70, 0x78,
							0x41, 0x49, 0x51, 0x59, 0x61, 0x69, 0x71, 0x79,
							0x42, 0x4a, 0x52, 0x5a, 0x62, 0x6a, 0x72, 0x7a,
							0x43, 0x4b, 0x53, 0x5b, 0x63, 0x6b, 0x73, 0x7b,
							0x45, 0x4d, 0x55, 0x5d, 0x65, 0x6d, 0x75, 0x7d,
							0x46, 0x4e, 0x56, 0x5e, 0x66, 0x6e, 0x76, 0x7e,
							0x47, 0x4f, 0x57, 0x5f, 0x67, 0x6f, 0x77, 0x7f);

my @state2_32 = (0x44, 0x4c, 0x54, 0x5c, 0x64, 0x6c, 0x74, 0x7c);

my @state4_32 = (0x05, 0x0d, 0x15, 0x1d, 0x25, 0x2d, 0x35, 0x3d,
							0x80, 0x88, 0x90, 0x98, 0xa0, 0xa8, 0xb0, 0xb8,
							0x81, 0x89, 0x91, 0x99, 0xa1, 0xa9, 0xb1, 0xb9,
							0x82, 0x8a, 0x92, 0x9a, 0xa2, 0xaa, 0xb2, 0xba,
							0x83, 0x8b, 0x93, 0x9b, 0xa3, 0xab, 0xb3, 0xbb,
							0x85, 0x8d, 0x95, 0x9d, 0xa5, 0xad, 0xb5, 0xbd,
							0x86, 0x8e, 0x96, 0x9e, 0xa6, 0xae, 0xb6, 0xbe,
							0x87, 0x8f, 0x97, 0x9f, 0xa7, 0xaf, 0xb7, 0xbf);
							
my @state5_32 = (0x84, 0x8c, 0x94, 0x9c, 0xa4, 0xac, 0xb4, 0xbc);

#foreach(@state1_16) {print}

foreach(@state1_16) { $stateModRM[$_] = 1;}
foreach(@state2_16) { $stateModRM[$_] = 2;}
foreach(@state1_32) { $stateModRM[$_] = 1;}
foreach(@state2_32) { $stateModRM[$_] = 2;}
foreach(@state4_32) { $stateModRM[$_] = 4;}
foreach(@state5_32) { $stateModRM[$_] = 5;}

print $out "modrmState ";
foreach( @stateModRM) {
	print $out " db $_\n";
}
close $out;