import { useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Icon, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { ScreenContacts } from './ScreenContacts';
import { ScreenHome } from './ScreenHome';
import { ScreenCalling, ScreenInCall } from './ScreenInCall';
import { ScreenIRC, ScreenViewingChannel } from './ScreenIRC';
import { ScreenMessages } from './ScreenMessages';
import { ScreenPhone } from './ScreenPhone';
import { ScreenRecents } from './ScreenRecents';

export type Contact = {
  name: string;
  number: string;
};

export type PhoneHistoryEntry = {
  type: string;
  name: string;
  number: string;
  time: string;
};

export type Comment = {
  body: string;
  author: string;
  time_stamp: string;
};

export type Message = {
  body: string;
  caption: string;
  author: string;
  time_stamp: string;
  comments: Comment[];
};

export type NewscasterChannel = {
  censored: BooleanLike;
  messages: Message[];
};

export type NewscasterChannelEntry = {
  name: string;
  censored: BooleanLike;
  ref: string;
};

export type Data = {
  calling: BooleanLike;
  online: BooleanLike;
  talking: BooleanLike;
  my_number: string;
  choosed_number: string;
  calling_user?: string;
  our_number: string;
  silence: BooleanLike;

  published_numbers: Contact[];
  our_contacts: Contact[];
  our_blocked_contacts: Contact[];

  phone_history: PhoneHistoryEntry[];

  newscaster_channels: NewscasterChannelEntry[];
  viewing_channel: null | NewscasterChannel;
};

export enum NavigableApps {
  // Browser, // TODO: Set up a server wiki that allows iframes
  Phone,
  Recents,
  Contacts,
  Messages,
  IRC,
}

const PhysicalScreen = (props: {
  app: NavigableApps | null;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { act, data } = useBackend<Data>();
  const { app, setApp } = props;

  if (data.calling) {
    return <ScreenCalling />;
  } else if (data.online) {
    return <ScreenInCall />;
  } else if (data.viewing_channel) {
    return <ScreenViewingChannel setApp={setApp} />;
  }

  const [enteredNumber, setEnteredNumber] = useSharedState('enteredNumber', '');

  switch (app) {
    case NavigableApps.Phone: {
      return (
        <ScreenPhone
          enteredNumber={enteredNumber}
          setEnteredNumber={setEnteredNumber}
          setApp={setApp}
        />
      );
    }
    case NavigableApps.Contacts: {
      return (
        <ScreenContacts
          enteredNumber={enteredNumber}
          setEnteredNumber={setEnteredNumber}
          setApp={setApp}
        />
      );
    }
    case NavigableApps.Recents: {
      return <ScreenRecents />;
    }
    case NavigableApps.Messages: {
      return <ScreenMessages />;
    }
    case NavigableApps.IRC: {
      return <ScreenIRC />;
    }
    default: {
      return <ScreenHome setApp={setApp} />;
    }
  }
};

const NavigationBar = (props: {
  app: NavigableApps | null;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { act, data } = useBackend<Data>();
  const { app, setApp } = props;

  let textColor = '#fff';
  if (
    app === NavigableApps.Phone ||
    app === NavigableApps.Contacts ||
    app === NavigableApps.Recents ||
    app === NavigableApps.Messages ||
    app === NavigableApps.IRC ||
    data.viewing_channel
  ) {
    textColor = '#000';
  }

  let backgroundColor: string | null = null;
  if (
    app === NavigableApps.Phone ||
    app === NavigableApps.Contacts ||
    app === NavigableApps.Recents ||
    app === NavigableApps.Messages ||
    app === NavigableApps.IRC ||
    data.viewing_channel
  ) {
    backgroundColor = '#0004';
  }

  return (
    <Box position="fixed" bottom={0} left={0} right={0} height={3}>
      <Stack
        fill
        textColor={textColor}
        backgroundColor={backgroundColor}
        align="center"
        justify="space-around"
      >
        <Stack.Item>
          <Box textAlign="center">
            <Icon name="bars" rotation={90} size={1.5} />
          </Box>
        </Stack.Item>
        <Stack.Item
          onClick={() => {
            act('viewing_newscaster_channel', { ref: null });
            setApp(null);
          }}
          className="Telephone__HomeButton"
          width={8}
          height="100%"
        >
          <Stack align="center" justify="center" fill>
            <Stack.Item>
              <Icon name="square-o" size={1.5} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Box textAlign="center">
            <Icon name="chevron-left" size={1.5} />
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const Telephone = (props) => {
  const [app, setApp] = useState<NavigableApps | null>(null);

  return (
    <Window width={285} height={521}>
      <Window.Content fitted>
        <PhysicalScreen app={app} setApp={setApp} />
        <NavigationBar app={app} setApp={setApp} />
      </Window.Content>
    </Window>
  );
};
