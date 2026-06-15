'use server';
/**
 * @fileOverview A Genkit flow to generate personalized martial arts workout routines.
 *
 * - generatePersonalizedWorkout - A function that handles the generation of a personalized workout routine.
 * - GeneratePersonalizedWorkoutInput - The input type for the generatePersonalizedWorkout function.
 * - GeneratePersonalizedWorkoutOutput - The return type for the generatePersonalizedWorkout function.
 */

import { ai } from '@/ai/genkit';
import { z } from 'genkit';

const GeneratePersonalizedWorkoutInputSchema = z.object({
  skillLevel: z
    .string()
    .describe(
      "The user's martial arts skill level (e.g., beginner, intermediate, advanced)."
    ),
  goals: z
    .array(z.string())
    .describe(
      "A list of the user's training goals (e.g., strength, endurance, specific techniques, flexibility)."
    ),
  equipment: z
    .array(z.string())
    .describe(
      "A list of available martial arts equipment (e.g., punching bag, gloves, focus mitts, jump rope, no equipment)."
    ),
  pastPerformance: z
    .string()
    .describe(
      "A summary of the user's past workout performance, including metrics or completed sessions. Provide details like 'last week I did 3x5 minute rounds of shadow boxing' or 'I want to improve my stamina after struggling with long cardio sessions'."
    ),
});
export type GeneratePersonalizedWorkoutInput = z.infer<
  typeof GeneratePersonalizedWorkoutInputSchema
>;

const GeneratePersonalizedWorkoutOutputSchema = z.object({
  workoutName: z.string().describe('A title for the workout routine.'),
  totalDurationMinutes: z
    .number()
    .describe('The estimated total duration of the workout in minutes.'),
  sections: z
    .array(
      z.object({
        name: z
          .string()
          .describe(
            'Name of the workout section (e.g., Warm-up, Technique Drills, Conditioning, Cool-down).'
          ),
        exercises: z
          .array(
            z.object({
              name: z
                .string()
                .describe(
                  'Name of the exercise (e.g., Shadow Boxing, Roundhouse Kicks).'
                ),
              description: z
                .string()
                .describe(
                  'Brief description or instructions for the exercise (e.g., "3 minutes of light jogging and dynamic stretches.").'
                ),
              durationMinutes: z
                .number()
                .optional()
                .describe('Duration of the exercise in minutes, if time-based.'),
              sets: z.number().optional().describe('Number of sets for the exercise.'),
              repsOrTime: z
                .string()
                .optional()
                .describe(
                  'Repetitions or specific time for each set (e.g., "10 reps", "30 seconds").'
                ),
              focus: z
                .array(z.string())
                .optional()
                .describe(
                  'Specific focus areas for this exercise (e.g., "speed", "power", "form", "cardio").'
                ),
            })
          )
          .describe('List of exercises within this section.'),
      })
    )
    .describe('A list of sections that make up the workout routine.'),
});
export type GeneratePersonalizedWorkoutOutput = z.infer<
  typeof GeneratePersonalizedWorkoutOutputSchema
>;

export async function generatePersonalizedWorkout(
  input: GeneratePersonalizedWorkoutInput
): Promise<GeneratePersonalizedWorkoutOutput> {
  return generatePersonalizedWorkoutFlow(input);
}

const workoutPrompt = ai.definePrompt({
  name: 'personalizedWorkoutPrompt',
  input: { schema: GeneratePersonalizedWorkoutInputSchema },
  output: { schema: GeneratePersonalizedWorkoutOutputSchema },
  prompt: `You are an expert martial arts coach and workout generator. Your task is to create a personalized martial arts workout routine based on the user's specific requirements. The workout should be tailored to their skill level, goals, available equipment, and past performance.

User's Skill Level: {{{skillLevel}}}
User's Goals: {{#each goals}}
- {{this}}{{/each}}
Available Equipment: {{#each equipment}}
- {{this}}{{/each}}
Past Performance Summary: {{{pastPerformance}}}

Generate a comprehensive workout routine in JSON format. Ensure the workout is well-structured with clear sections and exercises, and includes estimated total duration. The workout should be challenging yet appropriate for the user's stated skill level and goals.
`,
});

const generatePersonalizedWorkoutFlow = ai.defineFlow(
  {
    name: 'generatePersonalizedWorkoutFlow',
    inputSchema: GeneratePersonalizedWorkoutInputSchema,
    outputSchema: GeneratePersonalizedWorkoutOutputSchema,
  },
  async (input) => {
    const { output } = await workoutPrompt(input);
    return output!;
  }
);
