import pytest
from unittest.mock import AsyncMock, patch

from app.db.db import GameStatus
from app.services.game_events import emit_winner
from app.services.timer import emit_timer, time_left_tasks

from .db_setup import client, TestingSessionLocal, create_player, create_game


@pytest.fixture(scope="module")
def test_client():
    yield client


@pytest.mark.asyncio
@patch("app.services.timer.asyncio.sleep")
@patch("app.services.timer.Broadcast")
@patch("app.services.game.end_turn")
@pytest.mark.filterwarnings(
    "ignore:coroutine 'AsyncMockMixin._execute_mock_call' was never awaited:RuntimeWarning"
)
async def test_emit_timer(mock_end_turn, mock_broadcast, mock_sleep):
    db = TestingSessionLocal()
    game = create_game(db, GameStatus.INGAME)
    player = create_player(db, game.id)

    # Mock Broadcast
    mock_broadcast_instance = AsyncMock()
    mock_broadcast.return_value = mock_broadcast_instance

    time_left_tasks[game.id] = 120

    # Act
    await emit_timer(game.id, player.id, db)

    # Assert
    assert mock_broadcast_instance.broadcast.call_count == 120
    mock_end_turn.assert_called_once_with(game.id, player.id, db)


@pytest.mark.asyncio
@patch("app.services.cleanup.asyncio.sleep")
@patch("app.services.game_events.Broadcast")
async def test_emit_winner(mock_broadcast, mock_sleep):
    db = TestingSessionLocal()
    player = create_player(db, 1)

    # Mock Broadcast
    mock_broadcast_instance = AsyncMock()
    mock_broadcast.return_value = mock_broadcast_instance

    # Act
    await emit_winner(1, player.id, db)

    # Assert
    mock_broadcast_instance.broadcast.assert_called_once
