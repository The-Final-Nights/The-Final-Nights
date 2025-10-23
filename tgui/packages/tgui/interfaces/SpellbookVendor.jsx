import { classes } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table, Dropdown, Input, Collapsible } from 'tgui-core/components';
import { Window } from '../layouts';
import { useState } from 'react';

export const SpellbookVendor = (props) => {
  const { act, data } = useBackend();
  const [selectedTarget, setSelectedTarget] = useState(null);
  const [transferAmount, setTransferAmount] = useState('');

  const inventory = data.product_records || [];

  const getGreeting = () => {
    if (data.user && data.user.has_thaumaturgy) {
      return "Greetings, student of the blood...";
    } else {
      return "Greetings, seeker...";
    }
  };

  // Get selected member object
  const getSelectedMember = () => {
    if (!selectedTarget) return null;
    return (data.tremere_members || []).find(m => m.ref === selectedTarget);
  };

  // Handle point transfer
  const handleTransfer = () => {
    const selectedMember = getSelectedMember();
    if (!selectedMember || !transferAmount) {
      return;
    }

    const amount = parseInt(transferAmount);
    if (isNaN(amount) || amount <= 0) {
      return;
    }

    act('transfer_points', {
      target_ref: selectedMember.ref,
      amount: amount
    });

    setTransferAmount('');
  };

  const handleSeize = () => {
    const selectedMember = getSelectedMember();
    if (!selectedMember || !transferAmount) {
      return;
    }

    const amount = parseInt(transferAmount);
    if (isNaN(amount) || amount <= 0) {
      return;
    }

    act('seize_points', {
      target_ref: selectedMember.ref,
      amount: amount
    });

    setTransferAmount('');
  };

  // Create dropdown options
  const getDropdownOptions = () => {
    const members = data.tremere_members || [];
    if (members.length === 0) {
      return [];
    }
    return members.map(member => ({
      text: `${member.name} (${member.role}) - ${member.points} points`,
      value: member.ref
    }));
  };

  // Get the display text for selected member
  const getSelectedText = () => {
    if (!selectedTarget) {
      return 'Select a clan member...';
    }
    const selectedMember = getSelectedMember();
    if (!selectedMember) {
      return 'Select a clan member...';
    }
    return `${selectedMember.name} (${selectedMember.role}) - ${selectedMember.points} points`;
  };

  return (
    <Window width={465} height={700} resizable theme="blood_cult">
      <Window.Content scrollable>
        <Section
          title="Practitioner"
          style={{
            'background-color': '#1a0000',
            'border-color': '#4d0000',
            'color': '#cc3333'
          }}
        >
          {data.user && (
            <Box style={{ 'color': '#cc3333' }}>
              {getGreeting()}
              <br />
              You have <b style={{ 'color': '#ff4444' }}>
                {data.user.points} research points
              </b>.
            </Box>
          )}
        </Section>

        <Section
          title="The Archives"
          style={{
            'background-color': '#1a0000',
            'border-color': '#4d0000',
            'color': '#cc3333'
          }}
        >
          <Table style={{ 'background-color': '#0d0000' }}>
            {inventory.map((product) => {
              const canAfford = data.user && product.cost <= data.user.points;
              const inStock = product.available && product.stock > 0;
              const canPurchase = canAfford && inStock;

              // Determine button text and styling
              let buttonText = '';
              let buttonStyle = {};

              if (!inStock) {
                buttonText = 'Out of Stock!';
                buttonStyle = {
                  'min-width': '105px',
                  'text-align': 'center',
                  'background-color': '#2a2a2a',
                  'border-color': '#555555',
                  'color': '#888888',
                  'cursor': 'not-allowed'
                };
              } else {
                buttonText = product.cost + ' research points';
                buttonStyle = {
                  'min-width': '105px',
                  'text-align': 'center',
                  'background-color': canAfford ? '#660000' : '#4d1a1a',
                  'border-color': '#990000',
                  'color': canAfford ? '#ffcccc' : '#996666',
                  'transition': 'all 0.2s ease',
                  'cursor': canAfford ? 'pointer' : 'not-allowed'
                };
              }

              return (
                <Table.Row
                  key={product.name}
                  style={{
                    'background-color': '#1a0000',
                    'border-color': '#4d0000'
                  }}
                >
                  <Table.Cell style={{ 'color': '#cc3333' }}>
                    <span
                      className={classes(['vending32x32', product.path])}
                      style={{
                        'vertical-align': 'middle',
                        'filter': inStock ? 'hue-rotate(0deg) saturate(1.2) brightness(0.9)' : 'grayscale(100%) brightness(0.5)'
                      }}
                    />{' '}
                    <b style={{ 'color': inStock ? '#ff4444' : '#666666' }}>{product.name}</b>
                    <br />
                    <span style={{ 'font-size': '0.8em', 'color': inStock ? '#996666' : '#555555' }}>
                      Stock: {product.stock || 0}
                    </span>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={buttonStyle}
                      onMouseEnter={(e) => {
                        if (canPurchase) {
                          e.target.style.backgroundColor = '#990000';
                          e.target.style.color = '#ffffff';
                          e.target.style.borderColor = '#cc0000';
                          e.target.style.boxShadow = '0 0 8px rgba(204, 51, 51, 0.5)';
                        }
                      }}
                      onMouseLeave={(e) => {
                        if (canPurchase) {
                          e.target.style.backgroundColor = '#660000';
                          e.target.style.color = '#ffcccc';
                          e.target.style.borderColor = '#990000';
                          e.target.style.boxShadow = 'none';
                        }
                      }}
                      disabled={!canPurchase}
                      content={buttonText}
                      onClick={() =>
                        act('purchase', {
                          ref: product.ref,
                        })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              );
            })}
          </Table>
        </Section>

        {/* Tremere Network Section */}
        {data.tremere_members && data.tremere_members.length > 0 && (
          <Collapsible
            title="Tremere Network"
            style={{
              'background-color': '#1a0000',
              'border-color': '#4d0000',
              'color': '#cc3333'
            }}
          >
            <Section
              style={{
                'background-color': '#0d0000',
                'border-color': '#4d0000',
                'color': '#cc3333'
              }}
            >
              <Box style={{ 'margin-bottom': '10px', 'color': '#cc3333' }}>
                <b style={{ 'color': '#ff4444' }}>Clan Members:</b>
              </Box>

              <Table style={{ 'background-color': '#0d0000', 'margin-bottom': '15px' }}>
                {data.tremere_members.map((member) => (
                  <Table.Row
                    key={member.ref}
                    style={{
                      'background-color': '#1a0000',
                      'border-color': '#4d0000'
                    }}
                  >
                    <Table.Cell style={{ 'color': '#cc3333' }}>
                      <b style={{ 'color': '#ff4444' }}>{member.name}</b>
                      <br />
                      <span style={{ 'font-size': '0.9em', 'color': '#996666' }}>
                        {member.role}
                      </span>
                    </Table.Cell>
                    <Table.Cell style={{ 'color': '#cc3333', 'text-align': 'right' }}>
                      <b style={{ 'color': '#ff6666' }}>{member.points} points</b>
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>

              <Box style={{ 'margin-bottom': '10px' }}>
                <Box style={{ 'margin-bottom': '5px', 'color': '#cc3333' }}>
                  <b style={{ 'color': '#ff4444' }}>Select Target:</b>
                </Box>
                <Dropdown
                  width="100%"
                  options={getDropdownOptions()}
                  selected={getSelectedText()}
                  onSelected={(value) => {
                    console.log("Dropdown selected:", value);
                    setSelectedTarget(value);
                  }}
                  color="red"
                  style={{
                    'background-color': '#330000',
                    'border-color': '#660000',
                    'color': '#ffcccc'
                  }}
                />
              </Box>

              <Box style={{ 'margin-bottom': '10px' }}>
                <Box style={{ 'margin-bottom': '5px', 'color': '#cc3333' }}>
                  <b style={{ 'color': '#ff4444' }}>Amount:</b>
                </Box>
                <Input
                  width="100%"
                  placeholder="Enter amount..."
                  value={transferAmount}
                  onInput={(e, value) => setTransferAmount(value)}
                  style={{
                    'background-color': '#330000',
                    'border-color': '#660000',
                    'color': '#ffcccc'
                  }}
                />
              </Box>

              <Box style={{ 'display': 'flex', 'gap': '10px' }}>
                <Button
                  content="Transfer Points"
                  disabled={!selectedTarget || !transferAmount || parseInt(transferAmount) <= 0 || parseInt(transferAmount) > (data.user?.points || 0)}
                  onClick={handleTransfer}
                  style={{
                    'background-color': '#004d00',
                    'border-color': '#006600',
                    'color': '#ccffcc',
                    'flex': '1',
                    'transition': 'all 0.2s ease'
                  }}
                  onMouseEnter={(e) => {
                    if (!e.target.disabled) {
                      e.target.style.backgroundColor = '#006600';
                      e.target.style.borderColor = '#009900';
                      e.target.style.boxShadow = '0 0 8px rgba(51, 204, 51, 0.5)';
                    }
                  }}
                  onMouseLeave={(e) => {
                    if (!e.target.disabled) {
                      e.target.style.backgroundColor = '#004d00';
                      e.target.style.borderColor = '#006600';
                      e.target.style.boxShadow = 'none';
                    }
                  }}
                />

                {data.user && data.user.is_regent && (
                  <Button
                    content="Seize Points"
                    disabled={!selectedTarget || !transferAmount || parseInt(transferAmount) <= 0}
                    onClick={handleSeize}
                    style={{
                      'background-color': '#4d0000',
                      'border-color': '#660000',
                      'color': '#ffcccc',
                      'flex': '1',
                      'transition': 'all 0.2s ease'
                    }}
                    onMouseEnter={(e) => {
                      if (!e.target.disabled) {
                        e.target.style.backgroundColor = '#660000';
                        e.target.style.borderColor = '#990000';
                        e.target.style.boxShadow = '0 0 8px rgba(204, 51, 51, 0.5)';
                      }
                    }}
                    onMouseLeave={(e) => {
                      if (!e.target.disabled) {
                        e.target.style.backgroundColor = '#4d0000';
                        e.target.style.borderColor = '#660000';
                        e.target.style.boxShadow = 'none';
                      }
                    }}
                  />
                )}
              </Box>

              {data.user && data.user.is_regent && (
                <Box style={{ 'margin-top': '10px', 'font-size': '0.9em', 'color': '#996666' }}>
                  <i>As Regent, you may seize research points from any clan member.</i>
                </Box>
              )}
            </Section>
          </Collapsible>
        )}
      </Window.Content>
    </Window>
  );
};
