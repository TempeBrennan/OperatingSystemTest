int getEFlags(void);
void setEFlags(int eflags);

int getIsComputerAbove486();
void enableCache();
void disableCache();
unsigned int getEndAvailableMemoryAddr(unsigned int startAddr, unsigned int endAddr);

int getCR0(void);
void setCR0(int data);
