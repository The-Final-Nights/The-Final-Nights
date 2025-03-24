import { useBackend } from '../backend';
import { Box, Button, Flex, Input, Section, Stack } from '../components';
import { Window } from '../layouts';

export const PhoneChat = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    chat_messages = [],
    nickname = "",
  } = data;

  return (
    <Window
      title="Phone Chatroom"
      width={400}
      height={600}>
      <Window.Content>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <Flex>
                <Flex.Item grow>
                  <Input
                    fluid
                    placeholder="Set your nickname..."
                    value={nickname}
                    onChange={(e, value) => act('set_nickname', { nickname: value })}
                  />
                </Flex.Item>
              </Flex>
            </Stack.Item>
            <Stack.Item grow>
              <Box
                className="PhoneChat__messages"
                style={{
                  "height": "100%",
                  "overflow-y": "auto",
                  "padding": "10px",
                  "background-color": "rgba(0, 0, 0, 0.2)",
                }}>
                {chat_messages.map((message, index) => (
                  <Box key={index} mb={1}>
                    {message}
                  </Box>
                ))}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Flex>
                <Flex.Item grow>
                  <Input
                    fluid
                    placeholder="Type a message..."
                    onEnter={(e, value) => {
                      act('send_message', { message: value });
                      e.target.value = '';
                    }}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    ml={1}
                    onClick={() => act('send_message', { message: e.target.value })}
                  >
                    Send
                  </Button>
                </Flex.Item>
              </Flex>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
