import { useState } from 'react';
import { Box, Icon, Stack } from 'tgui-core/components';

export const Keyboard = (props: { onClick?: (keyPressed: string) => void }) => {
  const { onClick } = props;
  const [caps, setCaps] = useState(false);

  const keyHandler = (key: string) => {
    if (onClick) {
      onClick(key);
    }
  };

  return (
    <Stack vertical fill backgroundColor="#aed7ff" pt={1} pb={1}>
      <Stack.Item>
        <Stack align="center" justify="center">
          {['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'].map(
            (numberKey) => (
              <Stack.Item
                key={numberKey}
                onClick={() => keyHandler(numberKey)}
                style={{ cursor: 'pointer' }}
              >
                <Box
                  inline
                  width={1.8}
                  height={2}
                  backgroundColor="#beecff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>{numberKey}</Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            ),
          )}
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill align="center" justify="center">
          {['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'].map((key) => {
            if (!caps) {
              key = key.toLowerCase();
            }
            return (
              <Stack.Item
                key={key}
                onClick={() => keyHandler(key)}
                style={{ cursor: 'pointer' }}
              >
                <Box
                  inline
                  width={1.8}
                  height={2.4}
                  backgroundColor="#d5ffff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>{key}</Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            );
          })}
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill align="center" justify="center">
          {['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'].map((key) => {
            if (!caps) {
              key = key.toLowerCase();
            }
            return (
              <Stack.Item
                key={key}
                onClick={() => keyHandler(key)}
                style={{ cursor: 'pointer' }}
              >
                <Box
                  inline
                  width={1.8}
                  height={2.4}
                  backgroundColor="#d5ffff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>{key}</Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            );
          })}
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            <Box
              inline
              width={3}
              height={2.4}
              backgroundColor="#beecff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
                cursor: 'pointer',
              }}
              onClick={() => setCaps((x) => !x)}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="arrow-up" color={caps ? 'blue' : 'black'} />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          {['Z', 'X', 'C', 'V', 'B', 'N', 'M'].map((key) => {
            if (!caps) {
              key = key.toLowerCase();
            }
            return (
              <Stack.Item
                key={key}
                onClick={() => keyHandler(key)}
                style={{ cursor: 'pointer' }}
              >
                <Box
                  inline
                  width={1.8}
                  height={2.4}
                  backgroundColor="#d5ffff"
                  textColor="#000"
                  fontSize={1.2}
                  style={{
                    borderRadius: '4px',
                  }}
                >
                  <Stack fill align="center" justify="center">
                    <Stack.Item>{key}</Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            );
          })}
          <Stack.Item
            style={{ cursor: 'pointer' }}
            onClick={() => keyHandler('Backspace')}
          >
            <Box
              inline
              width={3}
              height={2.4}
              backgroundColor="#beecff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="delete-left" />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            <Box
              inline
              width={3}
              height={2.4}
              backgroundColor="#beecff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>Sym</Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box
              inline
              width={1.8}
              height={2.4}
              backgroundColor="#d5ffff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="microphone" />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item
            style={{ cursor: 'pointer' }}
            onClick={() => keyHandler(',')}
          >
            <Box
              inline
              width={1.8}
              height={2.4}
              backgroundColor="#d5ffff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>,</Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item
            style={{ cursor: 'pointer' }}
            onClick={() => keyHandler(' ')}
          >
            <Box
              width={8.7}
              height={2.4}
              backgroundColor="#d5ffff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
              }}
            >
              {' '}
            </Box>
          </Stack.Item>
          <Stack.Item
            style={{ cursor: 'pointer' }}
            onClick={() => keyHandler('.')}
          >
            <Box
              inline
              width={1.8}
              height={2.4}
              backgroundColor="#d5ffff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>.</Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item
            style={{ cursor: 'pointer' }}
            onClick={() => keyHandler('Enter')}
          >
            <Box
              inline
              width={3}
              height={2.4}
              backgroundColor="#beecff"
              textColor="#000"
              fontSize={1.2}
              style={{
                borderRadius: '4px',
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="arrow-turn-down" rotation={90} />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const ScreenMessages = (props) => {
  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item>
        <Box
          backgroundColor="#028ae4"
          textColor="#fff"
          pl={1}
          pb={1.5}
          pt={1.5}
          pr={1}
          verticalAlign="middle"
          fontSize={1.5}
        >
          <Stack align="center">
            <Stack.Item grow>Messages</Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      <Stack.Item grow mt={0}>
        Error: SMS Unsupported by current carrier.
      </Stack.Item>
      <Stack.Item mb={6}>
        <Keyboard />
      </Stack.Item>
    </Stack>
  );
};
