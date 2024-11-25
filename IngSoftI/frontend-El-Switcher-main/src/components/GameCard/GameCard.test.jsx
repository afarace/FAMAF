import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import GameCard from './GameCard';

// Mock del componente Button
vi.mock('../Button/Button', () => ({
  default: vi.fn(({ text, onPress, style }) => (
    <button onClick={onPress} className={style}>
      {text}
    </button>
  )),
}));

describe('GameCard', () => {
  const mockOnPressButton = vi.fn();

  const defaultProps = {
    gameName: 'Test Game',
    maxPlayers: 4,
    connectedPlayers: 2,
    isPublic: true,
  };

  const renderComponent = (props = {}) =>
    render(
      <GameCard
        {...defaultProps}
        {...props}
        onPressButton={mockOnPressButton}
      />
    );

  it('should render the GameCard component', () => {
    renderComponent();

    expect(screen.getByText('Test Game')).toBeInTheDocument();
    expect(screen.getByText('Conectados: 2')).toBeInTheDocument();
    expect(screen.getByText('Max. jugadores: 4')).toBeInTheDocument();
  });

  it('should render the button with correct text and style', () => {
    renderComponent();

    const button = screen.getByText('Unirme');
    expect(button).toBeInTheDocument();
    expect(button).toHaveClass('borderButton');
  });

  it('should call onPressButton when the button is clicked', () => {
    renderComponent();

    const button = screen.getByText('Unirme');
    fireEvent.click(button);
    expect(mockOnPressButton).toHaveBeenCalledTimes(1);
  });

  it('should render the unlocked icon when the game is public', () => {
    renderComponent({ isPublic: true });

    const icon = screen.getByAltText('Icono de candado');
    expect(icon).toBeInTheDocument();
    expect(icon).toHaveAttribute(
      'src',
      '/src/assets/Icons/padlock-unlocked.svg'
    );
  });

  it('should render the locked icon when the game is private', () => {
    renderComponent({ isPublic: false });

    const icon = screen.getByAltText('Icono de candado');
    expect(icon).toBeInTheDocument();
    expect(icon).toHaveAttribute('src', '/src/assets/Icons/padlock-locked.svg');
  });
});
