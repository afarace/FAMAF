import { z } from 'zod';
import { apiService } from './axiosConfig';

// Define the schema for the game object.
const gameSchema = z.object({
  gameId: z.number().int(), // must be an integer.
  gameName: z.string(), // must be a string.
  maxPlayers: z.number().int(), // must be an integer.
  minPlayers: z.number().int(), // must be an integer.
  status: z
    .string()
    .refine((value) => ['Lobby', 'Ingame', 'Finished'].includes(value)), // must be one of the specified strings.
});

/**
 * Fetches and validates a specific game by its ID from the backend API.
 *
 * @param {number} gameId - The ID of the game to fetch.
 * @returns {Promise<Object>} - A promise that resolves to the validated game object.
 * @throws {Error} - Throws an error if the API request fails or if the game validation fails.
 */
export const getGame = async (gameId) => {
  try {
    const response = await apiService.get(`/game/${gameId}`);
    const game = response.data;
    // Validate the game data. If it's invalid, throw an error.
    gameSchema.parse(game);

    return game;
  } catch (error) {
    console.error(`Errores al obtener la partida con ID ${gameId}:\n ${error}`); // Log the error.

    throw error; // Propagate the error to the caller.
  }
};
