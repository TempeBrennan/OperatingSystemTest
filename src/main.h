#define MessageQueueLength 32
void hlt(void);
void cli(void);
void sti(void);
void init(void);
void resume(void);

struct MessageQueue {
	char data[MessageQueueLength];
	int len;
	int start;
	int end;
};
