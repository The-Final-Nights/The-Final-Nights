import { Box, Icon, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Data, NavigableApps } from '.';

export const ScreenViewingChannel = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;
  const { act, data } = useBackend<Data>();
  const { viewing_channel } = data;

  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item>
        <Box
          backgroundColor="#008140"
          textColor="#fff"
          pl={1}
          pb={1.5}
          pt={1.5}
          pr={1}
          verticalAlign="middle"
          fontSize={1.5}
        >
          <Stack align="center">
            <Stack.Item grow>IRC</Stack.Item>
            <Stack.Item
              style={{ cursor: 'pointer' }}
              onClick={() => {
                setApp(NavigableApps.IRC);
                act('viewing_newscaster_channel', { ref: null });
              }}
            >
              <Icon name="arrow-left" />
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      <Stack.Item grow mb={6} mt={0} style={{ overflowY: 'scroll' }}>
        {viewing_channel ? (
          <>
            {viewing_channel.messages.map((message) => (
              <Box key={message.time_stamp} backgroundColor="#0004">
                <Box color="maroon">
                  Story by {message.author} - [{message.time_stamp}]
                </Box>
                <Box dangerouslySetInnerHTML={{ __html: message.body }} />
                {message.caption ? (
                  <Box>
                    Image attachment not viewable, caption: {message.caption}
                  </Box>
                ) : null}
              </Box>
            ))}
          </>
        ) : (
          'ERROR: Channel invalid.'
        )}
      </Stack.Item>
    </Stack>
  );
};

export const ScreenIRC = (props) => {
  const { act, data } = useBackend<Data>();
  const { newscaster_channels } = data;

  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item>
        <Box
          backgroundColor="#008140"
          textColor="#fff"
          pl={1}
          pb={1.5}
          pt={1.5}
          pr={1}
          verticalAlign="middle"
          fontSize={1.5}
        >
          <Stack align="center">
            <Stack.Item grow>IRC</Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      <Stack.Item grow mb={6} mt={0} style={{ overflowY: 'scroll' }}>
        {newscaster_channels.map((channel) => (
          <Box
            key={channel.ref}
            className="Telephone__ContactsElement"
            height={4}
            onClick={() =>
              act('viewing_newscaster_channel', { ref: channel.ref })
            }
          >
            <Stack fill align="center">
              <Stack.Item>
                {channel.name}{' '}
                {channel.censored ? (
                  <Box inline color="bad">
                    ***
                  </Box>
                ) : null}
              </Stack.Item>
            </Stack>
          </Box>
        ))}
      </Stack.Item>
    </Stack>
  );
};
