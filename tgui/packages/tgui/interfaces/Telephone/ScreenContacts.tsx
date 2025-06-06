import { useState } from 'react';
import { Box, Icon, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Contact, Data, NavigableApps } from '.';

const ContactElement = (props: {
  contact: Contact;
  deleteIcon?: string | null;
  onClick?: () => void;
  onDelete?: () => void;
}) => {
  const { contact, onClick, deleteIcon, onDelete } = props;
  const { act } = useBackend();

  return (
    <Stack align="center">
      <Stack.Item grow>
        <Stack
          align="center"
          pt={1}
          pb={1}
          pl={1}
          className="Telephone__ContactsElement"
          onClick={onClick}
        >
          <Stack.Item>
            <Box
              width={3}
              height={3}
              backgroundColor="#74b1d5"
              style={{ borderRadius: '50%' }}
              fontSize={1.5}
            >
              <Stack fill align="center" justify="center">
                <Stack.Item>{contact.name[0]}</Stack.Item>
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item grow>
            <Box>{contact.name}</Box>
            <Box textColor="#aaa">{contact.number || 'Unknown Number'}</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {deleteIcon ? (
        <Stack.Item
          className="Telephone__ContactsElement"
          mr={1}
          onClick={onDelete}
        >
          <Icon name={deleteIcon} size={1.5} />
        </Stack.Item>
      ) : null}
    </Stack>
  );
};

export const ScreenContacts = (props: {
  enteredNumber: string;
  setEnteredNumber: React.Dispatch<React.SetStateAction<string>>;
  setApp: React.Dispatch<React.SetStateAction<NavigableApps | null>>;
}) => {
  const { enteredNumber, setEnteredNumber, setApp } = props;
  const { act, data } = useBackend<Data>();
  const { my_number, published_numbers, our_contacts, our_blocked_contacts } =
    data;

  const [showSettings, setShowSettings] = useState(false);

  our_contacts.sort((a, b) => a.name.localeCompare(b.name));
  published_numbers.sort((a, b) => a.name.localeCompare(b.name));
  our_blocked_contacts.sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Stack vertical fill backgroundColor="#fff" textColor="#000">
      <Stack.Item>
        <Box
          backgroundColor="#d26f38"
          textColor="#fff"
          pl={1}
          pb={1.5}
          pt={1.5}
          pr={1}
          verticalAlign="middle"
          fontSize={1.5}
        >
          <Stack align="center">
            <Stack.Item grow>Contacts</Stack.Item>
            <Stack.Item
              style={{ cursor: 'pointer' }}
              onClick={() => setShowSettings((x) => !x)}
            >
              <Icon name="gear" />
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      {showSettings ? (
        <Stack.Item grow mb={6} mt={0}>
          <Box p={1} backgroundColor="#0003">
            This Phone&apos;s Number: {my_number}
          </Box>
          <Box
            p={1}
            onClick={() => act('publish_number')}
            className="Telephone__ContactsElement"
          >
            &gt; Publish Number
          </Box>
        </Stack.Item>
      ) : (
        <Stack.Item grow mb={6} mt={0} style={{ overflowY: 'scroll' }}>
          <Box p={1} backgroundColor="#0003">
            My Contacts
          </Box>
          {our_contacts.map((contact) => (
            <ContactElement
              contact={contact}
              key={contact.name + contact.number}
              deleteIcon="trash"
              onClick={() => {
                setEnteredNumber(contact.number);
                setApp(NavigableApps.Phone);
              }}
              onDelete={() => act('remove_contact', { name: contact.name })}
            />
          ))}
          <Box p={1} backgroundColor="#0003">
            Published Numbers
          </Box>
          {published_numbers.map((contact) => (
            <ContactElement
              contact={contact}
              key={contact.name + contact.number}
              onClick={() => {
                setEnteredNumber(contact.number);
                setApp(NavigableApps.Phone);
              }}
            />
          ))}
          <Box p={1} backgroundColor="#0003">
            Blocked Numbers
          </Box>
          {our_blocked_contacts.map((contact) => (
            <ContactElement
              contact={contact}
              key={contact.name + contact.number}
              deleteIcon="unlock"
              onClick={() => {
                setEnteredNumber(contact.number);
                setApp(NavigableApps.Phone);
              }}
              onDelete={() => act('unblock', { name: contact.name })}
            />
          ))}
        </Stack.Item>
      )}
    </Stack>
  );
};
