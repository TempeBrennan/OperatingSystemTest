#define MessageQueueLength 32
void hlt(void);
void cli(void);
void sti(void);
void init(void);
void resume(void);
void runMessageQueue();

struct MessageQueue {
	char data[MessageQueueLength];
	int len;
	int start;
	int end;
};

struct MouseMessage {
	unsigned char data[3];
	unsigned char phase;
};
int collectMouseMessage(struct MouseMessage* mouseMessage, unsigned char data);
