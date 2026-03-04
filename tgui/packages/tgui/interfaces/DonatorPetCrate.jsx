import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { Window } from '../layouts';

const PetButton = ({ pet }) => {
  const { act } = useBackend();
  return (
    <Button
      onClick={() => act('choose_pet', { pet_type: pet.type })}
      tooltip={pet.desc}
      tooltipPosition="bottom"
      style={{ width: '80px', height: '80px', textAlign: 'center' }}
    >
      <Stack vertical align="center" spacing={1}>
        <Stack.Item>
          <Box
            as="img"
            src={pet.icon}
            style={{ width: '32px', height: '32px' }}
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold fontSize="0.8em">{pet.name}</Box>
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

export const DonatorPetCrate = (props) => {
  const { data } = useBackend();
  const { categories = [] } = data;
  const [selected, setSelected] = useLocalState('category', null);

  const current = categories.find((c) => c.key === selected);

  return (
    <Window title="Choose Your Pet" width={460} height={300}>
      <Window.Content>
        {!current ? (
          <Section title="What kind of companion?">
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
            <Stack wrap spacing={2} style={{ rowGap: '8px' }}>
              {current.pets.map((pet) => (
                <Stack.Item key={pet.type}>
                  <PetButton pet={pet} />
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
