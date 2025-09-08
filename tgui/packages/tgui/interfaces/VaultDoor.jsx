import { useBackend } from '../backend';
import { Button, Section, Box } from 'tgui-core/components';
import { Window } from '../layouts';
import { Component } from 'react';

export class VaultDoor extends Component {
  constructor(props) {
    super(props);
    this.state = {
      inputCode: '',
      showFeedback: false,
      feedbackMessage: '',
      feedbackType: 'neutral'
    };

    this.handleButtonClick = this.handleButtonClick.bind(this);
    this.handleClear = this.handleClear.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleButtonClick(value) {
    if (this.state.inputCode.length < 8) {
      this.setState(prevState => ({
        inputCode: prevState.inputCode + value,
        showFeedback: false
      }));
    }
  }

  handleClear() {
    this.setState({
      inputCode: '',
      showFeedback: false
    });
  }

  handleSubmit() {
    if (this.state.inputCode.length === 0) return;

    const { act } = useBackend();
    act('submit_pincode', { pincode: this.state.inputCode });

    // Show temporary feedback
    this.setState({
      showFeedback: true,
      feedbackMessage: 'PROCESSING...',
      feedbackType: 'processing'
    });

    // Clear input after a delay
    setTimeout(() => {
      this.setState({ inputCode: '' });
    }, 1000);
  }

  render() {
    const { data } = useBackend();
    const { pincode } = data;
    const { inputCode, showFeedback, feedbackMessage, feedbackType } = this.state;

    const keypadStyle = {
      backgroundColor: '#1a1a1a',
      border: '3px solid #444',
      borderRadius: '12px',
      padding: '20px',
      fontFamily: 'monospace',
      boxShadow: 'inset 0 0 20px rgba(0,0,0,0.8)'
    };

    const displayStyle = {
      backgroundColor: '#000',
      border: '2px solid #333',
      borderRadius: '8px',
      padding: '15px',
      marginBottom: '20px',
      minHeight: '40px',
      fontSize: '24px',
      fontWeight: 'bold',
      textAlign: 'center',
      color: showFeedback ?
        (feedbackType === 'processing' ? '#ffaa00' : feedbackType === 'success' ? '#00ff00' : '#ff0000') :
        '#00ff00',
      textShadow: '0 0 10px currentColor',
      letterSpacing: '8px',
      fontFamily: 'monospace'
    };

    const buttonRowStyle = {
      display: 'flex',
      justifyContent: 'center',
      gap: '8px',
      marginBottom: '8px'
    };

    const numberButtonStyle = {
      width: '60px',
      height: '60px',
      fontSize: '20px',
      fontWeight: 'bold',
      backgroundColor: '#2a2a2a',
      border: '2px solid #555',
      borderRadius: '8px',
      color: '#ffffff',
      cursor: 'pointer',
      transition: 'all 0.1s',
      fontFamily: 'monospace'
    };

    const controlButtonStyle = {
      ...numberButtonStyle,
      width: '120px',
      height: '50px',
      fontSize: '16px',
      margin: '0 5px'
    };

    return (
      <Window width={350} height={450} resizable={false}>
        <Window.Content>
          <Section title="VAULT SECURITY SYSTEM" style={{backgroundColor: '#0a0a0a'}}>
            <Box style={keypadStyle}>
              {/* Display Screen */}
              <Box style={displayStyle}>
                {showFeedback ? feedbackMessage :
                  (inputCode.length > 0 ?
                    '●'.repeat(inputCode.length) + '_'.repeat(Math.max(0, 5 - inputCode.length)) :
                    'ENTER CODE'
                  )
                }
              </Box>

              <Box>
                <Box style={buttonRowStyle}>
                  <Button
                    style={numberButtonStyle}
                    content="1"
                    onClick={() => this.handleButtonClick('1')}
                  />
                  <Button
                    style={numberButtonStyle}
                    content="2"
                    onClick={() => this.handleButtonClick('2')}
                  />
                  <Button
                    style={numberButtonStyle}
                    content="3"
                    onClick={() => this.handleButtonClick('3')}
                  />
                </Box>

                <Box style={buttonRowStyle}>
                  <Button
                    style={numberButtonStyle}
                    content="4"
                    onClick={() => this.handleButtonClick('4')}
                  />
                  <Button
                    style={numberButtonStyle}
                    content="5"
                    onClick={() => this.handleButtonClick('5')}
                  />
                  <Button
                    style={numberButtonStyle}
                    content="6"
                    onClick={() => this.handleButtonClick('6')}
                  />
                </Box>

                <Box style={buttonRowStyle}>
                  <Button
                    style={numberButtonStyle}
                    content="7"
                    onClick={() => this.handleButtonClick('7')}
                  />
                  <Button
                    style={numberButtonStyle}
                    content="8"
                    onClick={() => this.handleButtonClick('8')}
                  />
                  <Button
                    style={numberButtonStyle}
                    content="9"
                    onClick={() => this.handleButtonClick('9')}
                  />
                </Box>

                <Box style={buttonRowStyle}>
                  <Button
                    style={{...numberButtonStyle, backgroundColor: '#333'}}
                    content="CLR"
                    onClick={this.handleClear}
                  />
                  <Button
                    style={numberButtonStyle}
                    content="0"
                    onClick={() => this.handleButtonClick('0')}
                  />
                  <Button
                    style={{...numberButtonStyle, backgroundColor: '#1a4d1a', color: '#00ff00'}}
                    content="ENT"
                    onClick={this.handleSubmit}
                    disabled={inputCode.length === 0}
                  />
                </Box>
              </Box>

              <Box style={{
                marginTop: '15px',
                padding: '8px',
                backgroundColor: '#111',
                border: '1px solid #333',
                borderRadius: '4px',
                textAlign: 'center',
                fontSize: '12px',
                color: '#888',
                fontFamily: 'monospace'
              }}>
                SECURITY LEVEL: HIGH | STATUS: LOCKED
              </Box>
            </Box>
          </Section>
        </Window.Content>
      </Window>
    );
  }
}
