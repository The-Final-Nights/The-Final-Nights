import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack, Tooltip } from 'tgui-core/components';

import { Data, NavigableApps } from '.';

export const ScreenPhone = (props: {
  enteredNumber: string;
  setEnteredNumber: React.Dispatch<React.SetStateAction<string>>;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { enteredNumber, setEnteredNumber, setApp } = props;
  const { act, data } = useBackend<Data>();
  const { silence } = data;

  const [settings, setSettings] = useState(false);

  const enterNumber = (digit: string) => {
    act('terminal_sound');

    if (digit === 'C') {
      setEnteredNumber('');
    } else if (digit === '_') {
      setEnteredNumber(enteredNumber + ' ');
    } else {
      setEnteredNumber(enteredNumber + digit);
    }
  };

  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item>
        <Stack fill align="center" justify="space-between" ml={2} mr={2} mt={1}>
          <Stack.Item>
            <Icon name="chevron-left" size={2} />
          </Stack.Item>
          <Stack.Item
            style={{ cursor: 'pointer' }}
            onClick={() => setSettings((x) => !x)}
          >
            <Icon
              name="ellipsis-vertical"
              color={settings ? 'blue' : ''}
              size={2}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {settings ? (
        <Stack.Item>
          <Stack vertical fill>
            <Stack.Item>
              <Stack
                fill
                align="center"
                justify="space-between"
                p={1}
                onClick={() => act('silent')}
                className="Telephone__ContactsElement"
              >
                <Stack.Item>Silent Mode:</Stack.Item>
                <Stack.Item>{silence ? 'On' : 'Off'}</Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ) : (
        <>
          <Stack.Item>
            <Stack align="center" justify="space-around">
              <Stack.Item
                p={1}
                className="Telephone__NumpadButton"
                onClick={() => setApp(NavigableApps.Recents)}
              >
                Recents
              </Stack.Item>
              <Stack.Item
                p={1}
                className="Telephone__NumpadButton"
                onClick={() => setApp(NavigableApps.Contacts)}
              >
                Contacts
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item mt={12}>
            <Box
              style={{
                borderTop: '2px solid #ccc',
                borderBottom: '2px solid #ccc',
              }}
              height={4}
            >
              <Stack fill align="center" justify="center">
                <Tooltip content="Add Contact">
                  <Stack.Item
                    textAlign="center"
                    ml={1}
                    mr={1}
                    style={{ cursor: 'pointer' }}
                    onClick={() =>
                      act('add_contact', { number: enteredNumber })
                    }
                  >
                    <Icon name="plus" size={2} />
                  </Stack.Item>
                </Tooltip>
                <Tooltip content="Block">
                  <Stack.Item
                    textAlign="center"
                    ml={1}
                    mr={1}
                    style={{ cursor: 'pointer' }}
                    onClick={() => act('block', { number: enteredNumber })}
                  >
                    <Icon name="shield" size={2} />
                  </Stack.Item>
                </Tooltip>
                <Stack.Item textAlign="center" fontSize={2} grow>
                  {enteredNumber}
                </Stack.Item>
                <Stack.Item textAlign="center" ml={1} mr={1}>
                  <Icon
                    name="delete-left"
                    size={2}
                    style={{ cursor: 'pointer' }}
                    onClick={() => enterNumber('C')}
                  />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box className="Telephone__NumpadGrid" textAlign="center">
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('1')}
              >
                <Box fontSize={2}>1</Box>
                <Icon name="voicemail" />
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('2')}
              >
                <Box fontSize={2}>2</Box>
                ABC
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('3')}
              >
                <Box fontSize={2}>3</Box>
                DEF
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('4')}
              >
                <Box fontSize={2}>4</Box>
                GHI
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('5')}
              >
                <Box fontSize={2}>5</Box>
                JKL
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('6')}
              >
                <Box fontSize={2}>6</Box>
                MNO
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('7')}
              >
                <Box fontSize={2}>7</Box>
                PQRS
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('8')}
              >
                <Box fontSize={2}>8</Box>
                TUV
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('9')}
              >
                <Box fontSize={2}>9</Box>
                WXYZ
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('#')}
              >
                <Box fontSize={2} mt={0.5}>
                  <Icon name="hashtag" fontWeight="1" />
                </Box>
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('0')}
              >
                <Box fontSize={2}>0</Box>
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('_')}
              >
                <Box fontSize={2} bold mt={0.5}>
                  _
                </Box>
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => enterNumber('+')}
              >
                <Stack fill align="center" justify="center">
                  <Stack.Item>
                    <Box fontSize={2}>+</Box>
                  </Stack.Item>
                </Stack>
              </Box>
              <Box
                className="Telephone__NumpadButton"
                onClick={() => {
                  setEnteredNumber('');
                  act('call', { number: enteredNumber });
                }}
              >
                <Stack fill align="center" justify="center">
                  <Stack.Item>
                    <Box
                      backgroundColor="#18885c"
                      style={{ borderRadius: '50%' }}
                      width={4}
                      height={4}
                    >
                      <Stack fill align="center" justify="center">
                        <Stack.Item>
                          <Icon name="phone" textColor="white" size={2} />
                        </Stack.Item>
                      </Stack>
                    </Box>
                  </Stack.Item>
                </Stack>
              </Box>
              <Box
                className="Telephone__NumpadButton"
                style={{ cursor: 'default' }}
              >
                <Box fontSize={2}>
                  <Icon name="braille" />
                </Box>
                Hide
              </Box>
            </Box>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};
