import { classes } from 'tgui-core/react';
import { useBackend } from "../backend";
import { Icon, Section, Table, Tooltip } from "tgui-core/components";
import { Window } from "../layouts";

const commandJobs = [
  'Primogen Malkavian',
  'Primogen Nosferatu',
  'Primogen Toreador',
  'Primogen Ventrue',
  'Primogen Banu Haqim',
  'Primogen Lasombra',
  'Chantry Regent',
];

export const CrewManifest = (props) => {
  const { data: { manifest, positions } } = useBackend();

  return (
    <Window title="Crew Manifest" width={350} height={500}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([dept, crew]) => (
          <Section
            className={"CrewManifest--" + dept}
            key={dept}
            title={
              dept + (dept !== "Citizen"
                ? ` (${positions[dept].open} positions open)` : "")
            }
          >
            <Table>
              {Object.entries(crew).map(([crewIndex, crewMember]) => (
                <Table.Row key={crewIndex}>
                  <Table.Cell className={"CrewManifest__Cell"}>
                    {crewMember.name}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      "CrewManifest__Cell",
                      "CrewManifest__Icons",
                    ])}
                    collapsing
                  >
                    {positions[dept].exceptions.includes(crewMember.rank) && (
                      <Icon className="CrewManifest__Icon" name="infinity">
                        <Tooltip
                          content="No position limit"
                          position="bottom"
                        />
                      </Icon>
                    )}
                    {crewMember.rank === "Prince" && (
                      <Icon
                        className={classes([
                          "CrewManifest__Icon",
                          "CrewManifest__Icon--Command",
                        ])}
                        name="star"
                      >
                        <Tooltip
                          content="Prince"
                          position="bottom"
                        />
                      </Icon>
                    )}
                    {commandJobs.includes(crewMember.rank) && (
                      <Icon
                        className={classes([
                          "CrewManifest__Icon",
                          "CrewManifest__Icon--Command",
                          "CrewManifest__Icon--Chevron",
                        ])}
                        name="chevron-up"
                      >
                        <Tooltip
                          content="Member of the Primogen Council"
                          position="bottom"
                        />
                      </Icon>
                    )}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      "CrewManifest__Cell",
                      "CrewManifest__Cell--Rank",
                    ])}
                    collapsing
                  >
                    {crewMember.rank}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
