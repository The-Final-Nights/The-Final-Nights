// THIS IS A SKYRAT UI FILE
import { ReactNode, useState } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Section, Stack, Tabs } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { Window } from '../layouts';

type ExamineData = {
  character_name: string;
  obscured: BooleanLike;
  flavor_text: string;
  flavor_text_nsfw: string;
  headshot: string,
  ooc_notes: string;
  character_notes: string;
  nsfw_content: BooleanLike;
}

function formatURLs(text: string) {
  if (!text) return;
  const parts: Array<string> = [];
  let regex = /https?:\/\/[^\s/$.?#].[^\s]*/gi;
  let lastIndex = 0;

  text.replace(regex, (url, index: number) => {
    parts.push(text.substring(lastIndex, index));
    parts.push(
      <a
        style={{
          color: '#0591e3',
          'text-decoration': 'none',
        }}
        href={url}
      >
        {url}
      </a>,
    );
    lastIndex = index + url.length;
    return url;
  });

  parts.push(text.substring(lastIndex));

  return <div>{parts}</div>;
};

export const ExaminePanel = (props) => {
  const [tabIndex, setTabIndex] = useState(1);
  const [lowerTabIndex, setLowerTabIndex] = useState(1);
  const { act, data } = useBackend<ExamineData>();
  const {
    character_name,
    obscured,
    flavor_text,
    flavor_text_nsfw,
    headshot,
    ooc_notes,
    character_notes,
    nsfw_content,
  } = data;
  return (
    <Window
      title={character_name + "'s Examine Panel"}
      width={900}
      height={670}
    >
      <Window.Content>
        <Stack fill>
          <Stack.Item width="30%">
            <Section height="310px" title="Headshot">
              <img
                src={
                  tabIndex === 2
                    ? resolveAsset(headshot)
                    : resolveAsset(headshot)
                }
                height="250px"
                width="250px"
              />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Tabs fluid>
              <Tabs.Tab
                selected={tabIndex === 1}
                onClick={() => setTabIndex(1)}
              >
                <Section fitted title={'Flavor Text'} />
              </Tabs.Tab>
              {nsfw_content && (
                <Tabs.Tab
                  selected={tabIndex === 2}
                  onClick={() => setTabIndex(2)}
                >
                  <Section fitted title={'Flavor Text (NSFW)'} />
                </Tabs.Tab>
              )}
            </Tabs>
            {tabIndex === 1 && (
              <Section
                style={{ 'overflow-y': 'scroll' }}
                fitted
                preserveWhitespace
                minHeight="50%"
                maxHeight="50%"
                fontSize="14px"
                lineHeight="1.7"
                textIndent="3em"
              >
                {formatURLs(flavor_text)}
              </Section>
            )}
            {tabIndex === 2 && (
              <Section
                style={{ 'overflow-y': 'scroll' }}
                fitted
                preserveWhitespace
                minHeight="50%"
                maxHeight="50%"
                fontSize="14px"
                lineHeight="1.7"
                textIndent="3em"
              >
                {formatURLs(flavor_text_nsfw)}
              </Section>
            )}
            <Tabs fluid>
              <Tabs.Tab
                selected={lowerTabIndex === 1}
                onClick={() => setLowerTabIndex(1)}
              >
                <Section fitted title={'Character Notes'} />
              </Tabs.Tab>
              {nsfw_content && (
                <Tabs.Tab
                  selected={lowerTabIndex === 2}
                  onClick={() => setLowerTabIndex(2)}
                >
                  <Section fitted title={'OOC Notes (NSFW)'} />
                </Tabs.Tab>
              )}
            </Tabs>
              {lowerTabIndex === 1 && (
                <Section
                  style={{ 'overflow-y': 'scroll' }}
                  preserveWhitespace
                  fitted
                  minHeight="35%"
                  maxHeight="35%"
                  fontSize="14px"
                  lineHeight="1.5"
                >
                  <Stack.Item>{formatURLs(character_notes)}</Stack.Item>
                </Section>
              )}
              {lowerTabIndex === 2 && (
                <Section
                  style={{ 'overflow-y': 'scroll' }}
                  preserveWhitespace
                  fitted
                  minHeight="35%"
                  maxHeight="35%"
                  fontSize="14px"
                  lineHeight="1.5"
                >
                  <Stack.Item>{formatURLs(ooc_notes)}</Stack.Item>
                </Section>
              )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
