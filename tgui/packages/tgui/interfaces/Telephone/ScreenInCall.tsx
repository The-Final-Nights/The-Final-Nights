import { Box, Icon, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../../backend';
import { Data } from '.';

const FakeCallingControls = (props: { calling: BooleanLike }) => {
  const { calling } = props;

  return (
    <Box className="Telephone__CallOptionsGrid" textAlign="center">
      {/* Add Call */}
      <Box textColor={calling ? '#fffa' : '#fff'}>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon name="plus" size={2} />
            </Stack.Item>
          </Stack>
        </Box>
        Add Call
      </Box>
      {/* Extra Volume */}
      <Box textColor={calling ? '#fffa' : '#fff'}>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon name="phone-volume" size={2} />
            </Stack.Item>
          </Stack>
        </Box>
        Extra Volume
      </Box>
      {/* Bluetooth */}
      <Box>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Box className="Telephone__BlueTooth" width={1.2} height={2} />
            </Stack.Item>
          </Stack>
        </Box>
        Bluetooth
      </Box>
      {/* Speaker */}
      <Box>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon name="volume-high" size={2} />
            </Stack.Item>
          </Stack>
        </Box>
        Speaker
      </Box>
      {/* Keypad */}
      <Box>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon name="keyboard" size={2} />
            </Stack.Item>
          </Stack>
        </Box>
        Keypad
      </Box>
      {/* Mute */}
      <Box textColor={calling ? '#fffa' : '#fff'}>
        <Box height={4}>
          <Stack fill align="center" justify="center">
            <Stack.Item>
              <Icon name="microphone-slash" size={2} />
            </Stack.Item>
          </Stack>
        </Box>
        Mute
      </Box>
    </Box>
  );
};

// This is separate from ScreenInCall because it's too difficult
// to manage a three-variable state machine in one component
export const ScreenCalling = (props) => {
  const { act, data } = useBackend<Data>();
  const { calling_user, calling, online, talking } = data;

  return (
    <Stack fill vertical className="Telephone__PhoneScreen">
      <Stack.Item>
        <Box mt={2} ml={2}>
          Calling...
        </Box>
      </Stack.Item>
      <Stack.Item height={15}>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            <Box bold fontSize={2} textAlign="center">
              {calling_user}
            </Box>
            <Box textAlign="center">San Franscisco</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <FakeCallingControls calling />
      </Stack.Item>
      <Stack.Item>
        <Stack mt={-3} fill align="center" justify="center">
          <Stack.Item>
            <Box
              backgroundColor="#fff"
              style={{
                borderRadius: '50%',
                cursor: 'pointer',
              }}
              height={4}
              width={4}
              onClick={() => {
                act('hang');
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="phone" textColor="red" size={2} rotation={135} />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const ScreenInCall = (props) => {
  const { act, data } = useBackend<Data>();
  const { calling_user, calling, online, talking } = data;

  return (
    <Stack fill vertical className="Telephone__PhoneScreen">
      <Stack.Item>
        <Box mt={2} ml={2}>
          {talking ? 'Online' : 'Call From'}
        </Box>
      </Stack.Item>
      <Stack.Item height={15}>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            <Box bold fontSize={2} textAlign="center">
              {calling_user}
            </Box>
            <Box textAlign="center">San Franscisco</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <FakeCallingControls calling />
      </Stack.Item>
      <Stack.Item>
        <Stack mt={-3} fill align="center" justify="center">
          {talking ? null : (
            <Stack.Item>
              <Box
                backgroundColor="#fff"
                style={{
                  borderRadius: '50%',
                  cursor: 'pointer',
                }}
                height={4}
                width={4}
                onClick={() => act('accept')}
              >
                <Stack fill align="center" justify="center">
                  <Stack.Item>
                    <Icon name="phone" textColor="green" size={2} />
                  </Stack.Item>
                </Stack>
              </Box>
            </Stack.Item>
          )}
          <Stack.Item>
            <Box
              backgroundColor="#fff"
              style={{
                borderRadius: '50%',
                cursor: 'pointer',
              }}
              height={4}
              width={4}
              onClick={() => {
                talking ? act('hang') : act('decline');
              }}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>
                  <Icon name="phone" textColor="red" size={2} rotation={135} />
                </Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
