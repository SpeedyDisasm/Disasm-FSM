#pragma once

#define PREFIX_LOCK 0xf0
#define PREFIX_ADDRESS_SIZE 0x67

typedef struct {
	UINT8 opcode;
	
	UINT8 prefix;
	
	//��� ���� ����� ����� ���� �������� ������, ����� �������� ���� ���� = 0x0
	//�� ������, ����� ���� ���� ��� � ����������, ������ bool ����������
	UINT state;
	
	UINT displacement;
	UINT immediate;
	//���� ������������ ����������. ���� ��� �������� ��� �������, �� ���� ����� �����
	BOOL valid;
} INSTRUCTION, *PINSTRUCTION;