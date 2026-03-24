import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { Window } from '../layouts';

const chunk = (arr, size) => {
  const chunks = [];
  for (let i = 0; i < arr.length; i += size) {
    chunks.push(arr.slice(i, i + size));
  }
  return chunks;
};

const PetButton = ({ plushie }) => {
  const { act } = useBackend();
  return (
    <Button
      onClick={() => act('choose_plushie', { plushie_type: plushie.type })}
      tooltip={plushie.desc}
      tooltipPosition="bottom"
      style={{ width: '80px', height: '80px', textAlign: 'center', overflow: 'hidden' }}
    >
      <Stack vertical align="center" spacing={1}>
        <Stack.Item>
          <Box
            as="img"
            src={plushie.icon}
            style={{ width: '32px', height: '32px' }}
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold fontSize="0.8em" style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}>{plushie.name}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
};

const CategoryButton = ({ category, onClick }) => (
  <Button
    onClick={onClick}
    style={{ width: '110px', height: '110px', textAlign: 'center' }}
  >
    <Stack vertical align="center" spacing={1}>
      <Stack.Item>
        <Box
          as="img"
          src={category.icon}
          style={{ width: '48px', height: '48px' }}
        />
      </Stack.Item>
      <Stack.Item>
        <Box bold>{category.label}</Box>
      </Stack.Item>
    </Stack>
  </Button>
);

export const DonatorPlushieBox = (props) => {
  const { data } = useBackend();
  const { categories = [] } = data;
  const [selected, setSelected] = useLocalState('category', null);

  const current = categories.find((c) => c.key === selected);

  return (
    <Window title="Choose a Plushie" width={420} height={380}>
      <Window.Content>
        {!current ? (
          <Section title="What kind of plushie?">
            <Stack justify="center" spacing={4}>
              {categories.map((cat) => (
                <Stack.Item key={cat.key}>
                  <CategoryButton category={cat} onClick={() => setSelected(cat.key)} />
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        ) : (
          <Section
            title={current.label}
            buttons={
              <Button icon="arrow-left" onClick={() => setSelected(null)}>
                Back
              </Button>
            }
          >
            <Stack vertical spacing={1}>
              {chunk(current.pets, 4).map((row, rowIdx) => (
                <Stack.Item key={rowIdx}>
                  <Stack spacing={2}>
                    {row.map((plushie) => (
                      <Stack.Item key={plushie.type}>
                        <PetButton plushie={plushie} />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
