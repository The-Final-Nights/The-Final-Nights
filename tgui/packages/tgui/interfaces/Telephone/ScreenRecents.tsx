import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui-core/components';

import { Data } from '.';

export const ScreenRecents = (props) => {
  const { act, data } = useBackend<Data>();
  const { phone_history } = data;

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
            <Stack.Item grow>Call History</Stack.Item>
            <Stack.Item
              style={{ cursor: 'pointer' }}
              onClick={() => act('delete_call_history')}
            >
              <Icon name="trash" />
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      <Stack.Item grow mb={6} mt={0} style={{ overflowY: 'scroll' }}>
        {phone_history.length === 0 ? 'No calls :)' : null}
        {phone_history.map((entry) => (
          <Box key={entry.time + entry.name + entry.number}>
            [{entry.time}]: {entry.name} ({entry.number}) called. {entry.type}.
          </Box>
        ))}
      </Stack.Item>
    </Stack>
  );
};
