import { PropsWithChildren, ReactNode } from 'react';
import { Box, Icon, Stack } from 'tgui-core/components';

import { NavigableApps } from '.';

export const AppIcon = (
  props: PropsWithChildren<{
    size?: number;
    backgroundColor?: string;
    iconColor?: string;
    iconName?: string;
    text?: ReactNode;
    onClick?: () => void;
  }>,
) => {
  const {
    children,
    size,
    backgroundColor,
    iconColor,
    iconName,
    text,
    onClick,
  } = props;

  const actualSize = size || 2;

  return (
    <Stack vertical align="center" justify="center" onClick={onClick}>
      <Stack.Item
        style={{
          cursor: onClick ? 'pointer' : 'default',
        }}
      >
        <Box
          backgroundColor={backgroundColor}
          height={actualSize * 2}
          width={actualSize * 2}
          style={{
            borderRadius: '30%',
          }}
        >
          <Stack justify="center" align="center" fill>
            <Stack.Item>
              {iconName ? (
                <Icon name={iconName} size={actualSize} textColor={iconColor} />
              ) : null}
              {children}
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      {text ? <Stack.Item fontSize={actualSize / 2}>{text}</Stack.Item> : null}
    </Stack>
  );
};

export const CameraAppIcon = (props) => {
  return (
    <AppIcon text="Camera">
      <Box
        className="Telephone__GalaxyS6Camera"
        p={4}
        style={{ borderRadius: '30%' }}
      />
    </AppIcon>
  );
};

export const ChromeAppIcon = (props: { onClick?: () => void }) => {
  const { onClick } = props;
  return (
    <AppIcon text="Chrome" size={1.6} backgroundColor="#fff" onClick={onClick}>
      <Box className="Telephone__Chrome" p={2.5} />
    </AppIcon>
  );
};

export const PlayStoreAppIcon = (props) => {
  return (
    <AppIcon text="Play Store" backgroundColor="#fff">
      <Box className="Telephone__PlayStore" p={2.5} />
    </AppIcon>
  );
};

export const IconDots = (props) => {
  return (
    <Box position="relative" ml={-2} mt={-2}>
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0}
        left={0}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0}
        left={0.75}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0}
        left={1.5}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0.75}
        left={0}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0.75}
        left={0.75}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={0.75}
        left={1.5}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={1.5}
        left={0}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={1.5}
        left={0.75}
        size={0.5}
      />
      <Icon
        name="circle"
        color="black"
        position="absolute"
        top={1.5}
        left={1.5}
        size={0.5}
      />
    </Box>
  );
};

export const GoogleSearchBar = (props) => {
  return (
    <Stack fill align="center" justify="center">
      <Stack.Item width="90%">
        <Box backgroundColor="#fff" style={{ borderRadius: '2px' }} height={3}>
          <Stack fill align="center" pl={1} pr={2}>
            <Stack.Item grow>
              <Box className="Telephone__Google" height={1.6} width={5} />
            </Stack.Item>
            <Stack.Item textColor="gray" mr={2}>
              Say &quot;Ok Google&quot;
            </Stack.Item>
            <Stack.Item>
              <Box className="Telephone__Mic" height={1.5} width={1} />
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
    </Stack>
  );
};

export const ScreenHome = (props: {
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { setApp } = props;

  return (
    <Stack fill vertical className="Telephone__HomeScreen">
      <Stack.Item grow>
        <Stack align="center" justify="space-between">
          <Stack.Item>
            <Box>
              <Box inline fontFamily="sans-serif" fontSize={4} ml={2} mt={2}>
                4:20
              </Box>
              PM
            </Box>
            <Box ml={2.5}>Monday, April 20</Box>
          </Stack.Item>
          <Stack.Item mr={2}>
            <Icon name="cloud" size={2} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item mb={2}>
        <GoogleSearchBar />
      </Stack.Item>
      <Stack.Item>
        <Stack fill align="center" justify="space-around" wrap="wrap">
          <Stack.Item>
            <AppIcon
              backgroundColor="#005555"
              text="IRC"
              onClick={() => setApp(NavigableApps.IRC)}
            >
              <Box fontSize={1.2} bold>
                I R C
              </Box>
            </AppIcon>
          </Stack.Item>
          <Stack.Item>
            <AppIcon
              backgroundColor="#fff"
              text="Email"
              iconName="envelope-open"
              iconColor="orange"
            />
          </Stack.Item>
          <Stack.Item>
            <CameraAppIcon />
          </Stack.Item>
          <Stack.Item>
            <PlayStoreAppIcon />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {/* Screen dots */}
      <Stack.Item height={1} p={2}>
        <Stack fill align="center" justify="center">
          <Stack.Item p={1}>
            <Icon name="house" color="white" />
          </Stack.Item>
          <Stack.Item p={1}>
            <Icon name="circle" color="#ffffffa0" />
          </Stack.Item>
          <Stack.Item p={1}>
            <Icon name="circle" color="#ffffffa0" />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {/* Bottom Bar */}
      <Stack.Item height={5} p={1} mb={7}>
        <Stack fill align="center" justify="space-around">
          <Stack.Item>
            <AppIcon
              size={1.6}
              backgroundColor="#00dd00"
              iconColor="white"
              iconName="phone"
              text="Phone"
              onClick={() => {
                setApp(NavigableApps.Phone);
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <AppIcon
              size={1.6}
              backgroundColor="#e58e1d"
              iconColor="white"
              iconName="user"
              text="Contacts"
              onClick={() => {
                setApp(NavigableApps.Contacts);
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <AppIcon
              size={1.6}
              backgroundColor="red"
              iconColor="white"
              iconName="comments"
              text="Message+"
              onClick={() => {
                setApp(NavigableApps.Messages);
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <ChromeAppIcon
            // onClick={() => {
            //   setApp(NavigableApps.Browser);
            // }}
            />
          </Stack.Item>
          <Stack.Item>
            <AppIcon
              size={1.6}
              backgroundColor="#eff6ff"
              iconColor="#798289"
              text="Apps"
            >
              <IconDots />
            </AppIcon>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
