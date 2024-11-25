import { renderHook, act } from '@testing-library/react';
import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { io } from 'socket.io-client';
import useWebsocketGame from './useWebsocketGame';
import { PlayerContext } from '../contexts/PlayerProvider';
import { useParams } from 'react-router-dom';

// Mock socket.io-client
vi.mock('socket.io-client');

// Mock useParams to avoid MemoryRouter and Routes
vi.mock('react-router-dom', async () => {
  // Import the actual module to preserve other functionalities
  const actual = await vi.importActual('react-router-dom');
  return {
    ...actual,
    useParams: vi.fn(),
  };
});

describe('useWebsocketGame Hook', () => {
  let socket;

  beforeEach(() => {
    socket = {
      on: vi.fn(),
      emit: vi.fn(),
      disconnect: vi.fn(),
    };
    io.mockReturnValue(socket);
    useParams.mockReturnValue({ gameId: '1' });
  });

  afterEach(() => {
    vi.resetAllMocks();
  });

  // Helper function to render the useWebsocketGame hook within a controlled test environment
  const renderUseWebsocketGameHook = (playerID = 1) => {
    const wrapper = ({ children }) => (
      <PlayerContext.Provider value={{ playerID }}>
        {children}
      </PlayerContext.Provider>
    );

    return renderHook(() => useWebsocketGame(), { wrapper });
  };

  // Helper function to get the callback for a specific event
  const getCallbackForEvent = (eventName) => {
    const call = socket.on.mock.calls.find((call) => call[0] === eventName);
    return call ? call[1] : null;
  };

  // Test initialization and event handling
  describe('Initialization and Event Handling', () => {
    it('should have initial state', () => {
      const { result } = renderUseWebsocketGameHook();

      expect(result.current.listOfPlayers).toEqual([]);
      expect(result.current.board).toEqual([]);
      expect(result.current.playerTurnId).toBe(-1);
      expect(result.current.figureCards).toEqual([]);
      expect(result.current.movementCards).toEqual([]);
      expect(result.current.winnerInfo).toBe(null);
      expect(result.current.opponentsTotalMovCards).toEqual([]);
      expect(result.current.foundFigures).toEqual([]);
      expect(result.current.chatMessages).toEqual([]);
      expect(result.current.timer).toBe(0);
      expect(result.current.blockedColor).toEqual(null);
      expect(result.current.hasNewMessages).toBe(false);
      expect(result.current.isChatOpen).toBe(false);
      expect(result.current.logMessages).toEqual([]);
    });

    it('should handle player_list event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const playerListCallback = getCallbackForEvent('player_list');
        if (playerListCallback) {
          playerListCallback([{ playerId: 1, name: 'Player 1' }]);
        }
      });

      expect(result.current.listOfPlayers).toEqual([
        { playerId: 1, name: 'Player 1' },
      ]);
    });

    it('should handle turn event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const turnCallback = getCallbackForEvent('turn');
        if (turnCallback) {
          turnCallback({ playerTurnId: 2 });
        }
      });

      expect(result.current.playerTurnId).toBe(2);
    });

    it('should handle board event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const boardCallback = getCallbackForEvent('board');
        if (boardCallback) {
          boardCallback([{ row: 1, column: 1 }]);
        }
      });

      expect(result.current.board).toEqual([{ row: 1, column: 1 }]);
    });

    it('should handle figure_cards event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const figureCardsCallback = getCallbackForEvent('figure_cards');
        if (figureCardsCallback) {
          figureCardsCallback([{ figureCardId: 1 }]);
        }
      });

      expect(result.current.figureCards).toEqual([{ figureCardId: 1 }]);
    });

    it('should handle movement_cards event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const movementCardsCallback = getCallbackForEvent('movement_cards');
        if (movementCardsCallback) {
          movementCardsCallback([{ movementcardId: 1 }]);
        }
      });

      expect(result.current.movementCards).toEqual([{ movementcardId: 1 }]);
    });

    it('should handle winner event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const winnerCallback = getCallbackForEvent('winner');
        if (winnerCallback) {
          winnerCallback({ winnerId: 1 });
        }
      });

      expect(result.current.winnerInfo).toEqual({ winnerId: 1 });
    });

    it('should handle opponents_total_mov_cards event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const opponentsTotalMovCardsCallback = getCallbackForEvent(
          'opponents_total_mov_cards'
        );
        if (opponentsTotalMovCardsCallback) {
          opponentsTotalMovCardsCallback([{ playerId: 2, totalMovCards: 3 }]);
        }
      });

      expect(result.current.opponentsTotalMovCards).toEqual([
        { playerId: 2, totalMovCards: 3 },
      ]);
    });

    it('should handle found_figures event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const foundFiguresCallback = getCallbackForEvent('found_figures');
        if (foundFiguresCallback) {
          foundFiguresCallback([{ figureId: 1 }]);
        }
      });

      expect(result.current.foundFigures).toEqual([{ figureId: 1 }]);
    });

    it('should handle timer event correctly', () => {
      const { result } = renderUseWebsocketGameHook();

      act(() => {
        const timerCallback = getCallbackForEvent('timer');
        if (timerCallback) {
          timerCallback({ time: 30 });
        }
      });

      expect(result.current.timer).toBe(30);
    });
  });

  it('should handle blocked_color event correctly', () => {
    const { result } = renderUseWebsocketGameHook();
    const blockedColor = 'red';

    act(() => {
      const blockedColorCallback = getCallbackForEvent('blocked_color');
      if (blockedColorCallback) {
        blockedColorCallback({ blockedColor });
      }
    });

    expect(result.current.blockedColor).toBe(blockedColor);
  });

  it('should handle chat multiple messages correctly', () => {
    const { result } = renderUseWebsocketGameHook();
    const data = [
      { writtenBy: 'Heber', message: 'Hello' },
      { writtenBy: 'John', message: 'Hi' },
    ];

    act(() => {
      const chatMessagesCallback = getCallbackForEvent('chat_messages');
      if (chatMessagesCallback) {
        chatMessagesCallback({
          type: 'multipleMessages',
          data,
        });
      }
    });

    expect(result.current.chatMessages).toEqual(data);
  });

  it('should handle chat single message correctly', () => {
    const { result } = renderUseWebsocketGameHook();
    const firstData = { writtenBy: 'Heber', message: 'Hello' };

    act(() => {
      const chatMessagesCallback = getCallbackForEvent('chat_messages');
      if (chatMessagesCallback) {
        chatMessagesCallback({
          type: 'singleMessage',
          data: firstData,
        });
      }
    });

    expect(result.current.chatMessages).toEqual([firstData]);

    const secondData = { writtenBy: 'John', message: 'Hi' };

    act(() => {
      const chatMessagesCallback = getCallbackForEvent('chat_messages');
      if (chatMessagesCallback) {
        chatMessagesCallback({
          type: 'singleMessage',
          data: secondData,
        });
      }
    });

    expect(result.current.chatMessages).toEqual([firstData, secondData]);
  });

  it('should handle game_logs multiple logs correctly', () => {
    const { result } = renderUseWebsocketGameHook();
    const data = [
      { message: 'Player 1 played one cards' },
      { message: 'Player 2 has 3 cards' },
    ];

    act(() => {
      const gameLogsCallback = getCallbackForEvent('game_logs');
      if (gameLogsCallback) {
        gameLogsCallback({
          type: 'multipleLogs',
          data,
        });
      }
    });

    expect(result.current.logMessages).toEqual(data);
  });

  it('should handle game_logs single log correctly', () => {
    const { result } = renderUseWebsocketGameHook();
    const firstData = { message: 'Player 1 played one cards' };

    act(() => {
      const gameLogsCallback = getCallbackForEvent('game_logs');
      if (gameLogsCallback) {
        gameLogsCallback({
          type: 'singleLog',
          data: firstData,
        });
      }
    });

    expect(result.current.logMessages).toEqual([firstData]);

    const secondData = { message: 'Player 2 has 3 cards' };

    act(() => {
      const gameLogsCallback = getCallbackForEvent('game_logs');
      if (gameLogsCallback) {
        gameLogsCallback({
          type: 'singleLog',
          data: secondData,
        });
      }
    });

    expect(result.current.logMessages).toEqual([firstData, secondData]);
  });

  // Test cleanup on unmount
  describe('Cleanup on Unmount', () => {
    it('should disconnect the socket on unmount', () => {
      const { unmount } = renderUseWebsocketGameHook();

      act(() => {
        unmount();
      });

      expect(socket.disconnect).toHaveBeenCalled();
    });
  });
});
