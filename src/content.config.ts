import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const briefing = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/briefing' }),
  schema: z.object({
    title: z.string(),
    kicker: z.string(),
    date: z.coerce.date(),
    author: z.string(),
    readingTime: z.string(),
    teaser: z.string(),
  }),
});

export const collections = { briefing };
