import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Flex,
  Icon,
  Input,
  LabeledList,
  Table,
} from 'tgui-core/components';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

// Constants
const COLORS = {
  blue: '#2573bc',
  lightBlue: '#56a0ea',
  darkBlue: '#0a246a',
  green: '#4f9e4f',
  red: '#b22222',
  grey: '#d4d0c8',
  darkGrey: '#808080',
  white: '#f8f6e9',
  black: '#000000',
  controlBg: '#ece9d8',
  controlBorder: '#ada89e',
  paperWhite: '#f8f6e9',
  medBackground: '#f5f3e4',
};

const ICONS = {
  categories: {
    'Controlled Substances': 'lock',
    'Medical Supplies': 'heart',
    'Medications': 'pills',
    'Staff Equipment': 'user-md',
    'Cleaning Supplies': 'spray-can',
    'Office Supplies': 'pencil-alt',
  },
  tabs: {
    requisition: 'heart',
    logs: 'clipboard-list',
    restock: 'boxes',
    admin: 'cog',
  },
};

const LOG_TYPE_STYLES = {
  login: { color: COLORS.green, icon: 'sign-in-alt' },
  logout: { color: COLORS.darkGrey, icon: 'sign-out-alt' },
  dispense: { color: COLORS.blue, icon: 'hand-holding-medical' },
  restock: { color: COLORS.green, icon: 'boxes' },
  override: { color: '#cc6600', icon: 'key' },
  emergency_mode: { color: COLORS.red, icon: 'exclamation-triangle' },
  deposit: { color: COLORS.green, icon: 'dollar-sign' },
};

// Utility functions
const safe = {
  array: (arr) => (Array.isArray(arr) ? arr : []),
  string: (str) => (typeof str === 'string' ? str : ''),
  bool: (bool) => Boolean(bool),
};

const getStockColor = (stock) => {
  if (stock <= 0) return '#b71c1c';
  if (stock < 3) return '#e65100';
  if (stock < 5) return '#f57f17';
  return '#2e7d32';
};

// Consolidated border styles
const BORDER_STYLES = {
  inset: {
    borderTop: '1px solid #808080',
    borderLeft: '1px solid #808080',
    borderRight: '1px solid #c0c0c0',
    borderBottom: '1px solid #c0c0c0',
  },
  outset: {
    borderTop: '1px solid #c0c0c0',
    borderLeft: '1px solid #c0c0c0',
    borderRight: '1px solid #808080',
    borderBottom: '1px solid #808080',
  },
};

// Base style generators
const createButtonStyle = (selected, disabled) => ({
  backgroundColor: selected ? COLORS.lightBlue : disabled ? '#f0f0f0' : COLORS.controlBg,
  border: `1px solid ${COLORS.controlBorder}`,
  borderRadius: '3px',
  color: selected ? COLORS.black : disabled ? COLORS.darkGrey : COLORS.black,
  padding: '2px 6px',
  margin: '1px',
  fontWeight: selected ? 'bold' : 'normal',
  cursor: disabled ? 'not-allowed' : 'pointer',
  boxShadow: selected ? 'inset 1px 1px 2px rgba(0,0,0,0.2)' : '1px 1px 1px rgba(0,0,0,0.1)',
});

const createWindowStyle = (extraStyle = {}) => ({
  border: `1px solid ${COLORS.blue}`,
  borderRadius: '3px',
  backgroundColor: COLORS.controlBg,
  marginBottom: '10px',
  boxShadow: '2px 2px 8px rgba(0, 0, 0, 0.25)',
  ...BORDER_STYLES.outset,
  ...extraStyle,
});

// Core components
const XPButton = ({ icon, content, selected, disabled, onClick, style, ...props }) => (
  <Button
    icon={icon}
    content={content}
    disabled={disabled}
    onClick={disabled ? null : onClick}
    style={{ ...createButtonStyle(selected, disabled), ...style }}
    {...props}
  />
);

const XPInput = ({ value, placeholder, onChange, ...props }) => (
  <Input
    placeholder={placeholder}
    value={value}
    fluid
    style={{
      color: COLORS.black,
      backgroundColor: COLORS.medBackground,
      border: `1px solid ${COLORS.controlBorder}`,
      ...BORDER_STYLES.inset,
      borderRadius: '2px',
      padding: '3px 5px',
      display: 'flex',
      alignItems: 'center',
      lineHeight: 'normal',
    }}
    onChange={onChange}
    {...props}
  />
);

const XPWindow = ({ title, icon, children, style, ...props }) => (
  <Box style={createWindowStyle(style)} {...props}>
    <Flex align="center" style={{
      background: `linear-gradient(to right, ${COLORS.darkBlue}, #a6caf0)`,
      color: COLORS.white,
      padding: '2px 8px',
      height: '22px',
      fontWeight: 'bold',
    }}>
      <Flex.Item>
        {icon && <Icon name={icon} mr={1} />}
        {title}
      </Flex.Item>
    </Flex>
    <Box p={1}>{children}</Box>
  </Box>
);

const XPNotice = ({ icon, children, style, ...props }) => (
  <Box style={{
    background: COLORS.controlBg,
    border: `1px solid ${COLORS.controlBorder}`,
    borderLeft: `4px solid ${COLORS.blue}`,
    ...BORDER_STYLES.outset,
    padding: '8px',
    marginBottom: '8px',
    borderRadius: '0 3px 3px 0',
    ...style,
  }} {...props}>
    <Flex align="center">
      {icon && <Flex.Item mr={1}><Icon name={icon} /></Flex.Item>}
      <Flex.Item grow={1}>{children}</Flex.Item>
    </Flex>
  </Box>
);

const ContentBox = ({ children, style, ...props }) => (
  <Box style={{
    backgroundColor: COLORS.paperWhite,
    borderRadius: '2px',
    overflowY: 'auto',
    padding: '6px',
    border: '1px solid #c0c0c0',
    ...BORDER_STYLES.inset,
    ...style,
  }} {...props}>
    {children}
  </Box>
);

// Specialized components
const ItemIcon = ({ icon }) => {
  if (!icon) return null;
  return (
    <Box style={{
      width: '32px', height: '32px', display: 'flex', justifyContent: 'center',
      alignItems: 'center', margin: '2px', backgroundColor: COLORS.medBackground,
      border: `1px solid ${COLORS.controlBorder}`,
      ...BORDER_STYLES.outset,
      borderRadius: '3px',
    }}>
      {typeof icon === 'string' && icon.length > 0 ? (
        <Box
          as="img"
          src={`data:image/png;base64,${icon}`}
          style={{ width: '100%', height: '100%', 'object-fit': 'contain' }}
          onError={(e) => { e.currentTarget.style.display = 'none'; }}
        />
      ) : (
        <Icon name="prescription-bottle-alt" size={1.5} />
      )}
    </Box>
  );
};

// Login component
const PyxisLogin = ({ messages }) => {
  const { act } = useBackend();
  const [showMessages, setShowMessages] = useState(safe.array(messages).length > 0);

  useEffect(() => {
    if (safe.array(messages).length > 0) setShowMessages(true);
  }, [messages]);

  return (
    <Box style={{ height: '100%', background: COLORS.controlBg, padding: '20px' }}>
      <Box mb={2}>
        <XPWindow title="Pyxis MedStation" icon="laptop-medical">
          <Box p={1} style={{
            background: `linear-gradient(to right, #356aa0, #9dc9ed)`,
            color: COLORS.white, textAlign: 'center', padding: '10px',
          }}>
            <Box fontSize="18px" fontWeight="bold" mb={1} color={COLORS.white}>St. John's Community Clinic</Box>
            <Box fontSize="12px" color={COLORS.white}>Automated Medication &amp; Supply Dispensing</Box>
          </Box>
        </XPWindow>
      </Box>

      <XPWindow title="User Authentication" icon="user-lock">
        <Box p={2}>
          <Flex direction="column" align="center">
            <Flex.Item mb={4}>
              <Icon name="first-aid" size={6} style={{
                color: '#cc3333', background: COLORS.paperWhite,
                border: '1px solid #e6e6e6', borderRadius: '50%',
                padding: '15px',
              }} />
            </Flex.Item>
            <Flex.Item mb={3} width="100%">
              <XPNotice icon="info-circle">
                <Box color={COLORS.black}>Please swipe or scan your ID card to access the system. This terminal is for authorized clinical staff only.</Box>
              </XPNotice>
            </Flex.Item>
            <Flex.Item mb={4} width="100%">
              <Box style={{
                border: `1px solid ${COLORS.controlBorder}`,
                padding: '20px', backgroundColor: COLORS.medBackground, textAlign: 'center',
              }}>
                <XPButton
                  icon="id-card"
                  content="Scan ID Card"
                  style={{
                    backgroundColor: COLORS.blue,
                    color: COLORS.white,
                    padding: '10px 20px',
                    fontWeight: 'bold',
                    fontSize: '14px',
                  }}
                  onClick={() => act('scan_id')}
                />
              </Box>
            </Flex.Item>
          </Flex>
        </Box>
      </XPWindow>

      <XPNotice icon="shield-alt">
        <Box textAlign="center" color={COLORS.black}>This system is for authorized clinical use only. All transactions are logged.</Box>
      </XPNotice>

      {showMessages && safe.array(messages).length > 0 && (
        <Box
          position="absolute"
          top="50%"
          left="50%"
          style={{ transform: 'translate(-50%, -50%)', 'z-index': 10, width: '400px' }}
        >
          <XPWindow title="System Messages" icon="comment">
            <Box p={1} color={COLORS.black}>
              {safe.array(messages).map((msg, i) => (
                <Box key={i} mb={1} color={COLORS.black}>{safe.string(msg)}</Box>
              ))}
              <Box mt={2} textAlign="right">
                <XPButton icon="times" content="Close" onClick={() => {
                  setShowMessages(false);
                  act('acknowledge_messages');
                }} />
              </Box>
            </Box>
          </XPWindow>
        </Box>
      )}
    </Box>
  );
};

// Main component
export const Pyxis = () => {
  const { act, data } = useBackend();
  const {
    logged_in = false, user_name = '', user_job = '', messages = [],
    emergency_mode = false, reminder = '', available_tabs = [], categories = [],
    selected_category = '',
  } = data;

  if (!logged_in) {
    return (
      <Window width={471} height={675} title="Pyxis MedStation" theme="winxp">
        <Window.Content scrollable={false} style={{ background: COLORS.controlBg }}>
          <PyxisLogin messages={messages} />
        </Window.Content>
      </Window>
    );
  }

  const [activeTab, setActiveTab] = useLocalState('tab', 'requisition');
  const [messageModalOpen, setMessageModalOpen] = useState(safe.array(messages).length > 0);

  useEffect(() => {
    if (logged_in && !selected_category && safe.array(categories).length > 0) {
      act('select_category', { category: categories[0].name });
    }
  }, [logged_in, selected_category, categories]);

  useEffect(() => {
    if (safe.array(messages).length > 0) setMessageModalOpen(true);
  }, [messages]);

  // Always reset to requisition tab when someone logs in
  useEffect(() => {
    if (logged_in) {
      setActiveTab('requisition');
    }
  }, [logged_in]);

  return (
    <Window width={1020} height={855} title="Pyxis MedStation" theme="winxp">
      <Window.Content style={{
        'background-color': COLORS.controlBg, color: COLORS.black,
        overflow: 'hidden', height: '100%',
      }}>
        <Flex direction="column" height="100%">
          <Flex.Item shrink={0}>
            <XPWindow title={`Pyxis MedStation - ${user_name} (${user_job})`} icon="laptop-medical">
              <Flex align="center" wrap="wrap">
                <Flex.Item grow={1}>
                  <Flex align="center">
                    {safe.array(available_tabs).map((tab) => (
                      <Flex.Item key={tab.key} ml={tab.key === 'requisition' ? 0 : 1}>
                        <XPButton
                          icon={ICONS.tabs[tab.key] || 'question'}
                          content={tab.label}
                          selected={activeTab === tab.key}
                          onClick={() => setActiveTab(tab.key)}
                        />
                      </Flex.Item>
                    ))}
                    {reminder && (
                      <Flex.Item ml={1}>
                        <Box opacity={0.8} italic fontSize="11px" color={COLORS.black}>{reminder}</Box>
                      </Flex.Item>
                    )}
                  </Flex>
                </Flex.Item>
                <Flex.Item>
                  <Flex align="center">
                    {safe.bool(emergency_mode) && (
                      <Flex.Item mr={1}>
                        <Box
                          backgroundColor={COLORS.red}
                          color="white"
                          p={1}
                          fontSize="14px"
                          bold
                          textAlign="center"
                          style={{ border: '1px solid #8b0000', borderRadius: '3px' }}
                        >
                          <Icon name="exclamation-triangle" mr={1} />EMERGENCY MODE
                        </Box>
                      </Flex.Item>
                    )}
                    <Flex.Item>
                      <XPButton icon="sign-out-alt" content="Logout" onClick={() => act('logout')} />
                    </Flex.Item>
                  </Flex>
                </Flex.Item>
              </Flex>
            </XPWindow>
          </Flex.Item>

          <Flex.Item grow={1} mt={1} style={{ overflow: 'hidden' }}>
            <Box height="100%" style={{ overflow: 'hidden' }}>
              {activeTab === 'requisition' && <PyxisRequisition />}
              {activeTab === 'logs' && <PyxisLogs />}
              {activeTab === 'restock' && <PyxisRestock />}
              {activeTab === 'admin' && <PyxisAdmin />}
            </Box>
          </Flex.Item>
        </Flex>

        {messageModalOpen && safe.array(messages).length > 0 && (
          <Box
            position="absolute"
            top="50%"
            left="50%"
            style={{ transform: 'translate(-50%, -50%)', 'z-index': 10, width: '400px' }}
          >
            <XPWindow title="System Messages" icon="comment">
              <Box p={1} color={COLORS.black}>
                {safe.array(messages).map((msg, i) => (
                  <Box key={i} mb={1} color={COLORS.black}>{safe.string(msg)}</Box>
                ))}
                <Box mt={2} textAlign="right">
                  <XPButton icon="times" content="Close" onClick={() => {
                    setMessageModalOpen(false);
                    act('acknowledge_messages');
                  }} />
                </Box>
              </Box>
            </XPWindow>
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};

// Tab components
const PyxisRequisition = () => {
  const { act, data } = useBackend();
  const {
    categories = [], selected_category = '', items = [], cart = [],
    category_access = false, reasons = [], selected_reason = '',
    notes = '', patient_name = '', category_overrides = {},
    category_access_override = false, can_override = false,
    dispense_disabled = false,
  } = data;

  const [overrideOpen, setOverrideOpen] = useLocalState('override', false);
  const [overrideData, setOverrideData] = useState({ physician: '', reason: '' });

  return (
    <Flex direction="column" height="100%">
      <Flex.Item shrink={0}>
        <XPWindow title="Categories" icon="folder">
          <Flex wrap="wrap" justify="flex-start">
            {safe.array(categories)
              .sort((a, b) => a.name.localeCompare(b.name))
              .map((category) => (
                <Flex.Item key={category.name} m={0.5}>
                  <XPButton
                    icon={ICONS.categories[category.name] || 'box'}
                    content={category.name}
                    selected={category.name === selected_category}
                    onClick={() => act('select_category', { category: category.name })}
                  />
                </Flex.Item>
              ))}
          </Flex>
        </XPWindow>
      </Flex.Item>

      <Flex.Item mt={0.5} grow={1}>
        <Flex height="100%">
          <Flex.Item basis="60%" mr={0.5}>
            <XPWindow title={selected_category || 'None Selected'} icon="pills">
              <ContentBox style={{ height: '450px' }}>
                {/* Access Notice */}
                {!(safe.bool(category_access) || safe.bool(category_access_override)) && (
                  <XPNotice icon="lock">
                    <Flex align="center">
                      <Flex.Item>Access to this category is restricted.</Flex.Item>
                      <Flex.Item grow={1} />
                      <Flex.Item>
                        {safe.bool(can_override) && <XPButton icon="key" content="Override" onClick={() => setOverrideOpen(true)} />}
                      </Flex.Item>
                    </Flex>
                  </XPNotice>
                )}

                {safe.bool(category_access_override) && category_overrides[selected_category] && (
                  <XPNotice icon="key" mb={1}>
                    <Box>
                      Access override active. Authorized by: <b>{safe.string(category_overrides[selected_category].physician)}</b>
                      <Box color={COLORS.darkGrey} fontSize="11px">Reason: {safe.string(category_overrides[selected_category].reason)}</Box>
                    </Box>
                  </XPNotice>
                )}

                {/* Items Table */}
                <Table>
                  <Table.Row header>
                    <Table.Cell style={{ fontWeight: 'bold', backgroundColor: COLORS.controlBg, padding: '4px 8px' }}>
                      Item
                    </Table.Cell>
                    <Table.Cell collapsing style={{ fontWeight: 'bold', backgroundColor: COLORS.controlBg, padding: '4px 8px', textAlign: 'center' }}>
                      Stock
                    </Table.Cell>
                    <Table.Cell collapsing style={{ fontWeight: 'bold', backgroundColor: COLORS.controlBg, padding: '4px 8px', textAlign: 'center' }}>
                      Action
                    </Table.Cell>
                  </Table.Row>
                  {safe.array(items).length === 0 ? (
                    <Table.Row>
                      <Table.Cell colSpan={3} textAlign="center">No items in this category.</Table.Cell>
                    </Table.Row>
                  ) : (
                    safe.array(items)
                      .sort((a, b) => a.name.localeCompare(b.name))
                      .map((item, i) => (
                        <Table.Row key={i} className="candystripe">
                          <Table.Cell style={{ verticalAlign: 'middle' }}>
                            <Flex align="center">
                              <ItemIcon icon={item.icon} />
                              <Flex.Item>{item.name}</Flex.Item>
                            </Flex>
                          </Table.Cell>
                          <Table.Cell collapsing textAlign="center" style={{ verticalAlign: 'middle' }}>
                            <Box color={getStockColor(item.stock)} fontWeight="bold">{item.stock}</Box>
                          </Table.Cell>
                          <Table.Cell collapsing style={{ verticalAlign: 'middle' }}>
                            <XPButton
                              icon="plus"
                              content="Add"
                              disabled={item.disabled}
                              onClick={() => act('add_to_cart', { id: item.id || (i + 1) })}
                            />
                          </Table.Cell>
                        </Table.Row>
                      ))
                  )}
                </Table>
              </ContentBox>
            </XPWindow>
          </Flex.Item>

          <Flex.Item grow={1}>
            <XPWindow title="Shopping Cart" icon="shopping-cart">
              <ContentBox style={{ height: '450px' }}>
                <Flex direction="column" height="100%">
                  <Flex.Item grow={1} style={{ overflowY: 'auto' }}>
                    <Table>
                      <Table.Row header>
                        <Table.Cell>Item</Table.Cell>
                        <Table.Cell collapsing>Amount</Table.Cell>
                        <Table.Cell collapsing>Actions</Table.Cell>
                      </Table.Row>
                      {safe.array(cart).length === 0 ? (
                        <Table.Row>
                          <Table.Cell colSpan={3} textAlign="center">Cart is empty</Table.Cell>
                        </Table.Row>
                      ) : (
                        safe.array(cart)
                          .sort((a, b) => a.name.localeCompare(b.name))
                          .map((item, i) => (
                            <Table.Row key={i} className="candystripe">
                              <Table.Cell>
                                <Flex align="center">
                                  <ItemIcon icon={item.icon} />
                                  <Flex.Item>{item.name}</Flex.Item>
                                </Flex>
                              </Table.Cell>
                              <Table.Cell textAlign="center">{item.amount}</Table.Cell>
                              <Table.Cell>
                                <XPButton icon="minus" onClick={() => act('remove_from_cart', { id: item.id || (i + 1) })} />
                              </Table.Cell>
                            </Table.Row>
                          ))
                      )}
                    </Table>
                  </Flex.Item>
                  {safe.array(cart).length > 0 && (
                    <Flex.Item shrink={0} mt={1} textAlign="right">
                      <XPButton
                        icon="trash"
                        content="Clear Cart"
                        style={{ backgroundColor: COLORS.red }}
                        onClick={() => act('clear_cart')}
                      />
                    </Flex.Item>
                  )}
                </Flex>
              </ContentBox>
            </XPWindow>
          </Flex.Item>
        </Flex>
      </Flex.Item>

      <Flex.Item shrink={0} mt={0.5}>
        <XPWindow title="Patient Information" icon="user-injured">
          <Flex>
            <Flex.Item basis="30%" mr={0.5}>
              <LabeledList>
                <LabeledList.Item label="Patient Name">
                  <XPInput
                    placeholder="Enter patient name"
                    value={patient_name}
                    onChange={(e, value) => act('set_patient_name', { name: value })}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Notes">
                  <XPInput
                    placeholder="Enter notes (optional)"
                    value={notes}
                    onChange={(e, value) => act('set_notes', { notes: value })}
                  />
                </LabeledList.Item>
              </LabeledList>
              <Box mt={2} textAlign="center">
                <XPButton
                  width="150px"
                  icon="hand-holding-medical"
                  content="Dispense"
                  disabled={dispense_disabled}
                  style={{
                    backgroundColor: COLORS.green,
                    fontWeight: 'bold',
                    padding: '6px 12px',
                  }}
                  onClick={() => act('dispense')}
                />
              </Box>
            </Flex.Item>
            <Flex.Item basis="70%" grow={1}>
              <Box mb={1} fontWeight="bold">Reason:</Box>
              <ContentBox style={{
                maxHeight: '100px',
                backgroundColor: COLORS.medBackground
              }}>
                <Flex wrap="wrap" justify="flex-start">
                  {safe.array(reasons)
                    .sort((a, b) => a.localeCompare(b))
                    .map((reason) => (
                      <Flex.Item key={reason} m={0.5} shrink={0}>
                        <XPButton
                          content={reason}
                          selected={reason === selected_reason}
                          onClick={() => act('select_reason', { reason })}
                          style={{ maxWidth: '200px', overflow: 'hidden', textOverflow: 'ellipsis' }}
                        />
                      </Flex.Item>
                    ))}
                </Flex>
              </ContentBox>
            </Flex.Item>
          </Flex>
        </XPWindow>
      </Flex.Item>

      {overrideOpen && (
        <Box
          position="absolute"
          top="50%"
          left="50%"
          style={{ transform: 'translate(-50%, -50%)', 'z-index': 10, width: '400px' }}
        >
          <XPWindow title="Access Override" icon="shield-alt">
            <Box p={1} color={COLORS.black}>
              <Box mb={2}>Enter authorizing physician name and reason for access override:</Box>
              <LabeledList>
                <LabeledList.Item label="Physician">
                  <XPInput
                    placeholder="Authorizing physician"
                    value={overrideData.physician}
                    onChange={(e, value) => setOverrideData({ ...overrideData, physician: value })}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Reason">
                  <XPInput
                    placeholder="Reason for override"
                    value={overrideData.reason}
                    onChange={(e, value) => setOverrideData({ ...overrideData, reason: value })}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Category">
                  {selected_category || 'None selected'}
                </LabeledList.Item>
              </LabeledList>
              <Box mt={2} textAlign="right">
                <XPButton icon="times" content="Cancel" onClick={() => setOverrideOpen(false)} />
                <XPButton
                  icon="check"
                  content="Confirm"
                  ml={1}
                  disabled={!overrideData.physician || !overrideData.reason}
                  onClick={() => {
                    act('set_access_override', {
                      physician: overrideData.physician,
                      reason: overrideData.reason,
                      category: selected_category,
                    });
                    setOverrideOpen(false);
                  }}
                />
              </Box>
            </Box>
          </XPWindow>
        </Box>
      )}
    </Flex>
  );
};

// Log utility functions
const formatLogDetails = (details) => {
  if (!details) return 'No details';

  if (details.includes('Items dispensed for patient:')) {
    const parts = details.split(' - ');
    let formatted = '';

    parts.forEach(part => {
      if (part.includes('patient:')) {
        const patient = part.split('patient: ')[1];
        formatted += `Patient: ${patient}\n`;
      } else if (part.includes('Reason:')) {
        const reason = part.split('Reason: ')[1];
        formatted += `Reason: ${reason}\n`;
      } else if (part.includes('Items:')) {
        const items = part.split('Items: ')[1];
        formatted += `Items: ${items}`;
      }
    });

    return formatted || details;
  }

  return details;
};

const getLogTypeStyle = (type) =>
  LOG_TYPE_STYLES[type] || { color: COLORS.black, icon: 'info-circle' };

const formatLogTimestamp = (timestamp) => {
  if (!timestamp) return 'N/A';
  return safe.string(timestamp);
};

// Log entry component
const LogEntry = ({ entry, index }) => {
  const typeStyle = getLogTypeStyle(entry.type);
  const formattedTimestamp = formatLogTimestamp(entry?.timestamp);
  const isEvenRow = index % 2 === 0;

  // Extract user name and job from the user field
  const userInfo = safe.string(entry?.user) || 'System';
  const userName = userInfo.includes('(') ? userInfo.split('(')[0].trim() : userInfo;
  const userJob = userInfo.includes('(') ? userInfo.split('(')[1].replace(')', '').trim() : '';

  return (
    <Box
      style={{
        backgroundColor: isEvenRow ? COLORS.paperWhite : COLORS.medBackground,
        margin: '1px 0',
        padding: '3px',
      }}
    >
      <Flex align="stretch">
        {/* Timestamp */}
        <Flex.Item basis="120px" shrink={0}>
          <Box
            style={{
              backgroundColor: COLORS.controlBg,
              border: `1px solid ${COLORS.controlBorder}`,
              ...BORDER_STYLES.inset,
              padding: '4px',
              fontFamily: 'monospace',
              fontSize: '11px',
              textAlign: 'center',
              color: COLORS.black,
              height: '100%',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            {formattedTimestamp}
          </Box>
        </Flex.Item>

        {/* Action Type */}
        <Flex.Item basis="120px" shrink={0} ml={1}>
          <Box
            style={{
              backgroundColor: typeStyle.color,
              color: 'white',
              padding: '4px',
              border: `1px solid ${COLORS.controlBorder}`,
              ...BORDER_STYLES.outset,
              textAlign: 'center',
              fontWeight: 'bold',
              fontSize: '11px',
              height: '100%',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              wordWrap: 'break-word',
              overflow: 'hidden',
            }}
          >
            <Box style={{ display: 'flex', alignItems: 'center', flexWrap: 'wrap', justifyContent: 'center' }}>
              <Icon name={typeStyle.icon} mr={1} />
              <Box style={{ wordBreak: 'normal', textAlign: 'center', whiteSpace: 'normal' }}>
                {(safe.string(entry?.type).toUpperCase() || 'UNKNOWN').replace('_', ' ')}
              </Box>
            </Box>
          </Box>
        </Flex.Item>

        {/* User */}
        <Flex.Item basis="120px" shrink={0} ml={1}>
          <Box
            style={{
              backgroundColor: COLORS.controlBg,
              border: `1px solid ${COLORS.controlBorder}`,
              ...BORDER_STYLES.inset,
              padding: '4px',
              fontSize: '11px',
              color: COLORS.black,
              height: '100%',
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'center',
              alignItems: 'center',
              overflow: 'hidden',
            }}
          >
            <Box style={{ display: 'flex', alignItems: 'center', flexWrap: 'wrap', justifyContent: 'center' }}>
              <Icon name="user" mr={1} size={0.8} />
              <Box fontWeight="bold" style={{ wordBreak: 'normal', textAlign: 'center', whiteSpace: 'normal' }}>
                {userName}
              </Box>
            </Box>
            {userJob && (
              <Box fontSize="9px" color={COLORS.darkGrey} mt={0.5} style={{ wordBreak: 'normal', textAlign: 'center', whiteSpace: 'normal' }}>
                {userJob}
              </Box>
            )}
          </Box>
        </Flex.Item>

        {/* Details */}
        <Flex.Item grow={1} ml={1}>
          <Box
            style={{
              backgroundColor: COLORS.paperWhite,
              border: `1px solid ${COLORS.controlBorder}`,
              ...BORDER_STYLES.inset,
              padding: '4px',
              minHeight: '24px',
              display: 'flex',
              alignItems: 'flex-start',
            }}
          >
            <Box
              style={{
                whiteSpace: 'pre-line',
                lineHeight: '1.3',
                fontSize: '11px',
                color: COLORS.black,
                width: '100%',
                wordBreak: 'normal',
                overflow: 'hidden',
              }}
            >
              {formatLogDetails(entry?.details)}
            </Box>
          </Box>
        </Flex.Item>
      </Flex>
    </Box>
  );
};

// Log headers component
const LogHeaders = () => (
  <Box
    style={{
      backgroundColor: COLORS.controlBg,
      border: `1px solid ${COLORS.controlBorder}`,
      ...BORDER_STYLES.outset,
      margin: '0 0 2px 0',
      padding: '3px',
    }}
  >
    <Flex align="center">
      {['Timestamp', 'Action', 'User', 'Details'].map((header, index) => (
        <Flex.Item
          key={header}
          basis={header === 'Details' ? undefined : '120px'}
          shrink={0}
          grow={header === 'Details' ? 1 : 0}
          ml={index > 0 ? 1 : 0}
        >
          <Box
            style={{
              padding: '4px',
              fontSize: '11px',
              fontWeight: 'bold',
              textAlign: 'center',
              color: COLORS.black,
            }}
          >
            {header}
          </Box>
        </Flex.Item>
      ))}
    </Flex>
  </Box>
);

const PyxisLogs = () => {
  const { data } = useBackend();
  const { logs = {} } = data;
  const allLogs = safe.array(logs.all || []);

    return (
    <XPWindow title="System Activity Log" icon="clipboard-list">
      <ContentBox style={{ height: '700px', padding: '4px' }}>
        {allLogs.length === 0 ? (
          <XPNotice icon="clipboard-list" style={{
            textAlign: 'center',
            marginTop: '50px',
            border: `2px dashed ${COLORS.controlBorder}`,
          }}>
            <Box fontSize="16px" fontWeight="bold" mb={1}>
              No System Logs Available
            </Box>
            <Box fontSize="12px">
              System activity will appear here as it occurs
            </Box>
          </XPNotice>
        ) : (
          <Box>
            <LogHeaders />
            {allLogs.map((entry, i) => (
              <LogEntry key={i} entry={entry} index={i} />
            ))}
          </Box>
        )}
      </ContentBox>
    </XPWindow>
  );
};

const PyxisRestock = () => {
  const { act, data } = useBackend();
  const { restock_items = [], stored_money = 0 } = data;

  return (
    <XPWindow title="Restock Management" icon="boxes">
      <ContentBox mb={2} p={1}>
        <LabeledList>
          <LabeledList.Item label="Available Funds">
            <Box inline bold>${stored_money}</Box>
          </LabeledList.Item>
        </LabeledList>
      </ContentBox>

      <XPNotice icon="info-circle" mb={2}>
        The restock system calculates costs based on the base price per unit.
        Restocking adds up to 5 units per transaction (to a maximum stock level of 15).
        A 10% bulk discount is applied when restocking 5 or more units.
      </XPNotice>

      <ContentBox style={{ height: '600px' }}>
        <Table>
          <Table.Row header>
            <Table.Cell>Item</Table.Cell>
            <Table.Cell collapsing>Current Stock</Table.Cell>
            <Table.Cell collapsing>Base Cost</Table.Cell>
            <Table.Cell collapsing>Total Cost</Table.Cell>
            <Table.Cell collapsing>Action</Table.Cell>
          </Table.Row>
          {restock_items.length === 0 ? (
            <Table.Row>
              <Table.Cell colSpan={5} textAlign="center">No items need restocking</Table.Cell>
            </Table.Row>
          ) : (
            restock_items
              .sort((a, b) => a.name.localeCompare(b.name))
              .map((item, i) => (
                <Table.Row key={i} className="candystripe">
                  <Table.Cell>
                    <Flex align="center">
                      <ItemIcon icon={item.icon} />
                      <Flex.Item>{item.name}</Flex.Item>
                    </Flex>
                  </Table.Cell>
                  <Table.Cell textAlign="center">
                    <Box color={getStockColor(item.stock)} fontWeight="bold">{item.stock}</Box>
                  </Table.Cell>
                  <Table.Cell textAlign="right">${item.base_cost}/unit</Table.Cell>
                  <Table.Cell textAlign="right">${item.cost}</Table.Cell>
                  <Table.Cell>
                    <XPButton
                      icon="boxes"
                      content={`Restock (${item.restock_amount})`}
                      disabled={item.disabled}
                      onClick={() => act('restock', { id: item.id })}
                    />
                  </Table.Cell>
                </Table.Row>
              ))
          )}
        </Table>
      </ContentBox>
    </XPWindow>
  );
};

const PyxisAdmin = () => {
  const { act, data } = useBackend();
  const { emergency_mode = false, stored_money = 0 } = data;

  return (
    <XPWindow title="Administration" icon="cog">
      <Box style={{ padding: '10px' }}>
        <LabeledList>
          <LabeledList.Item label="Emergency Mode">
            <Box>
              <XPButton
                icon={safe.bool(emergency_mode) ? "lock-open" : "lock"}
                content={safe.bool(emergency_mode) ? "Deactivate Emergency Mode" : "Activate Emergency Mode"}
                style={{
                  backgroundColor: safe.bool(emergency_mode) ? COLORS.red : COLORS.green,
                  border: `1px solid ${COLORS.controlBorder}`,
                  padding: '6px 12px',
                  fontWeight: 'bold',
                  color: COLORS.black,
                }}
                onClick={() => act('toggle_emergency')}
              />
              <Box mt={1} color={COLORS.darkGrey} fontSize="11px">
                Warning: Emergency mode bypasses access restrictions
              </Box>
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="System Funds">
            ${stored_money} available
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </XPWindow>
  );
};
