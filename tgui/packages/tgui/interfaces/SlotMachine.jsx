import { useBackend, useLocalState } from '../backend';
import { Box, Button, Stack } from 'tgui-core/components';
import { Window } from '../layouts';

const ALL_SYMBOLS = ['cherry', 'bar', 'bell', 'diamond', 'seven'];
const SYMBOL = {
  cherry:  { glyph: '🍒', color: '#ff5555', fontSize: '1.8em' },
  bar:     { glyph: 'BAR', color: '#f5e642', fontSize: '1.1em', fontFamily: 'serif', fontWeight: 'bold', letterSpacing: '3px' },
  bell:    { glyph: '🔔', color: '#ffdd00', fontSize: '1.8em' },
  diamond: { glyph: '💎', color: '#88eeff', fontSize: '1.8em' },
  seven:   { glyph: '7', color: '#ff2222', fontSize: '2.6em', fontWeight: 'bold' },
};

const paysymbolstuff = [
  { symbols: ['seven',   'seven',   'seven'],  payout: 77, jackpot: true }, // TODO: remove magic numbers here
  { symbols: ['diamond', 'diamond', 'diamond'], payout: 25 },
  { symbols: ['bell',    'bell',    'bell'],    payout: 10 },
  { symbols: ['bar',     'bar',     'bar'],     payout: 5 },
  { symbols: ['cherry',  'cherry',  'cherry'],  payout: 3 },
  { symbols: ['cherry',  'cherry',  null],      payout: 1 },
];

const REEL_CSS = `
@keyframes reel-drop {
  0%   { transform: translateY(-88px); opacity: 0.4; }
  65%  { transform: translateY(6px);   opacity: 1;   }
  100% { transform: translateY(0px);   opacity: 1;   }
}
`;
const STOP_TICKS = [50, 65, 70];

const randSymbol = () => ALL_SYMBOLS[Math.floor(Math.random() * ALL_SYMBOLS.length)];

const Glyph = ({ symbol, size }) => {
  const s = SYMBOL[symbol] || SYMBOL.cherry;
  return (
    <Box
      style={{
        color: s.color,
        fontSize: size === 'large' ? s.fontSize : '0.9em',
        fontFamily: s.fontFamily || 'inherit',
        fontWeight: s.fontWeight || 'normal',
        letterSpacing: s.letterSpacing || 'normal',
        lineHeight: 1,
      }}
    >
      {s.glyph}
    </Box>
  );
};

const Reel = ({ symbol, reelState, spinKey }) => {
  const isMoving = reelState !== 'stopped';
  return (
    <Box
      style={{
        width: '76px',
        height: '88px',
        background: '#fffbe6',
        border: `3px solid ${isMoving ? '#ddaa44' : '#bba060'}`,
        boxShadow: 'inset 0 2px 6px rgba(0,0,0,0.5)',
        borderRadius: '4px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        userSelect: 'none',
        overflow: 'hidden',
      }}
    >
      <Box
        key={spinKey}
        style={{
          animation: isMoving ? 'reel-drop 0.1s ease-out' : 'none',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          width: '100%',
          height: '100%',
        }}
      >
        <Glyph symbol={symbol} size="large" />
      </Box>
    </Box>
  );
};

const Paysymbols = ({ entry }) => (
  <Box
    style={{
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      padding: '3px 6px',
      borderBottom: '1px solid #2e1a04',
      background: entry.jackpot ? 'rgba(255, 34, 0, 0.08)' : 'transparent',
    }}
  >
    <Box style={{ display: 'flex', alignItems: 'center', gap: '3px' }}>
      {entry.symbols.map((s, i) =>
        s ? (
          <Glyph key={i} symbol={s} size="small" />
        ) : (
          <Box key={i} style={{ color: '#9a7a40', fontSize: '0.75em' }}>any</Box>
        )
      )}
    </Box>
    <Box
      style={{
        color: entry.jackpot ? '#ff4400' : '#ffd700',
        fontWeight: 'bold',
        fontSize: entry.jackpot ? '1em' : '0.85em',
        marginLeft: '8px',
        minWidth: '32px',
        textAlign: 'right',
      }}
    >
      {entry.jackpot ? '77 🎉' : `${entry.payout}`}
    </Box>
  </Box>
);

export const SlotMachine = () => {
  const { data, act } = useBackend();
  const { reels = ['seven', 'seven', 'seven'], payout = 0, result, credits = 0 } = data;

  const [animating, setAnimating] = useLocalState('animating', false);
  const [reelStates, setReelStates] = useLocalState('reelStates', ['stopped', 'stopped', 'stopped']); //yey sprite updates
  const [displaySymbols, setDisplaySymbols] = useLocalState('displaySymbols', ['seven', 'seven', 'seven']);
  const [reelKeys, setReelKeys] = useLocalState('reelKeys', [0, 0, 0]);

  const handleSpin = () => {
    if (animating || credits < 1) return;
    setAnimating(true);
    act('spin');

    const localStates = ['spinning', 'spinning', 'spinning']; //SPIN THE CHAMBER
    const localKeys = [0, 0, 0];
    const localSymbols = [randSymbol(), randSymbol(), randSymbol()];

    setReelStates([...localStates]);
    setReelKeys([...localKeys]);
    setDisplaySymbols([...localSymbols]);

    let tick = 0;
    const interval = setInterval(() => {
      tick++;

      for (let i = 0; i < 3; i++) {
        if (localStates[i] === 'spinning') {
          if (tick === STOP_TICKS[i]) {
            localStates[i] = 'stopping';
            localKeys[i]++;
          } else {
            localSymbols[i] = randSymbol();
            localKeys[i]++;
          }
        } else if (localStates[i] === 'stopping') {
          localStates[i] = 'stopped'; //WE'RE RICH!
        }
      }

      setReelStates([...localStates]);
      setReelKeys([...localKeys]);
      setDisplaySymbols([...localSymbols]);

      if (tick > STOP_TICKS[2]) {
        clearInterval(interval);
        setAnimating(false);
      }
    }, 100);
  };
  // random stuff until we have our final result. what you see is a LIE. the house always wins.
  const getSymbol = (i) => {
    if (reelStates[i] === 'stopped' || reelStates[i] === 'stopping') return reels[i];
    return displaySymbols[i];
  };

  const winner = !animating && payout > 0;
  const jackpot = !animating && payout >= 77; // todo: remove magic numbers and pull values from the back end
  const canSpin = !animating && credits >= 1;

  return (
    <Window title="Slot Machine" width={520} height={375}>
      <Window.Content
        style={{
          background: 'linear-gradient(180deg, #2a0a00 0%, #150300 100%)',
          padding: '8px',
        }}
      >
        <style>{REEL_CSS}</style>
        <Box
          style={{
            textAlign: 'center',
            fontSize: '1.15em',
            fontWeight: 'bold',
            letterSpacing: '4px',
            color: '#ffd700',
            textShadow: '0 0 10px #ff8800, 0 0 20px #ff4400',
            marginBottom: '8px',
            padding: '4px 0',
          }}
        >
          🎰 WHEEL OF MONEY 🎰
        </Box>

        <Stack fill spacing={1} style={{ alignItems: 'flex-start' }}>
          <Stack.Item
            style={{
              width: '185px',
              border: '2px solid #8b6914',
              borderRadius: '6px',
              background: '#180800',
              padding: '4px 0',
              flexShrink: 0,
              alignSelf: 'flex-start',
            }}
          >
            <Box
              style={{
                textAlign: 'center',
                fontSize: '0.75em',
                letterSpacing: '3px',
                color: '#ffd700',
                borderBottom: '1px solid #3a2a10',
                paddingBottom: '4px',
                marginBottom: '2px',
                fontWeight: 'bold',
              }}
            >
              ★ PAYS ★
            </Box>
            {paysymbolstuff.map((entry, i) => ( //the list of payouts. should probably define this on the back end
              <Paysymbols key={i} entry={entry} />
            ))}
            <Box
              style={{
                padding: '5px 8px 2px',
                fontSize: '0.72em',
                color: '#9a7040',
                borderTop: '1px solid #2e1a04',
                marginTop: '3px',
              }}
            >
              Cost: $1 per spin
            </Box>
          </Stack.Item>
          <Stack.Item grow style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '10px' }}>
            <Box
              style={{
                display: 'flex',
                gap: '8px',
                background: '#080000',
                border: '4px solid #8b6914',
                borderRadius: '8px',
                padding: '14px 16px',
                boxShadow: 'inset 0 4px 12px rgba(0,0,0,0.8)',
              }}
            >
              {[0, 1, 2].map((i) => (
                <Reel
                  key={i}
                  symbol={getSymbol(i)}
                  reelState={reelStates[i]}
                  spinKey={reelKeys[i]}
                />
              ))}
            </Box>
            <Box
              style={{
                height: '26px',
                fontSize: '1em',
                fontWeight: 'bold',
                color: jackpot ? '#ff4400' : winner ? '#44ff88' : '#aa7733',
                textShadow: winner ? '0 0 12px currentColor' : 'none',
                textAlign: 'center',
                letterSpacing: jackpot ? '2px' : 'normal',
              }}
            >
              {animating ? '' : (result || 'Insert chips and pull the lever!')}
            </Box>
            <Button
              onClick={handleSpin}
              disabled={!canSpin}
              style={{
                width: '200px',
                height: '46px',
                fontSize: '1em',
                fontWeight: 'bold',
                letterSpacing: '2px',
                background: animating
                  ? '#333333'
                  : credits < 1
                    ? '#2a2a2a'
                    : '#aa1a00',
                color: canSpin ? '#ffd700' : '#666',
                border: `2px solid ${canSpin ? '#8b6914' : '#444'}`,
                borderRadius: '6px',
                textShadow: canSpin ? '0 0 8px #ff8800' : 'none',
                cursor: canSpin ? 'pointer' : 'not-allowed',
              }}
            >
              {animating
                ? '> > >  SPINNING...'
                : credits < 1
                  ? '- INSERT CHIPS -'
                  : '🎰  PULL LEVER'}
            </Button>
            <Box style={{ fontSize: '0.95em', color: '#c8a84b', textAlign: 'center' }}>
              Credits:{' '}
              <Box as="span" bold style={{ color: credits > 0 ? '#ffd700' : '#666', fontSize: '1.1em' }}>
                ${credits}
              </Box>
            </Box>
            <Button
              onClick={() => act('cashout')}
              disabled={animating || credits <= 0}
              style={{
                width: '200px',
                height: '32px',
                fontSize: '0.85em',
                fontWeight: 'bold',
                letterSpacing: '1px',
                background: credits > 0 && !animating ? '#1a4a1a' : '#1a1a1a',
                color: credits > 0 && !animating ? '#88ff88' : '#444',
                border: `1px solid ${credits > 0 && !animating ? '#336633' : '#333'}`,
                borderRadius: '4px',
                cursor: credits > 0 && !animating ? 'pointer' : 'not-allowed',
              }}
            >
              CASH OUT
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
