<script lang="ts">
  import Board from '$lib/components/Board.svelte';

  type Player = 'X' | 'O';
  type Cell = Player | null;

  // Game state using Svelte 5 $state for reactivity
  let board = $state<Cell[]>(Array(9).fill(null));
  let currentPlayer = $state<Player>('X');
  let winner = $state<Player | null>(null);
  let isDraw = $state<boolean>(false);
  let winningLine = $state<number[] | null>(null);

  // All winning combinations (indices)
  const lines: number[][] = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  // PUBLIC_INTERFACE
  export function resetGame() {
    /** Resets the Tic Tac Toe game to the initial state. */
    board = Array(9).fill(null);
    currentPlayer = 'X';
    winner = null;
    isDraw = false;
    winningLine = null;
  }

  function checkWinner(b: Cell[]): { winner: Player | null; line: number[] | null } {
    for (const [a, c, d] of lines) {
      if (b[a] && b[a] === b[c] && b[a] === b[d]) {
        return { winner: b[a] as Player, line: [a, c, d] };
      }
    }
    return { winner: null, line: null };
  }

  function handleMove(e: CustomEvent<{ index: number }>) {
    const { index } = e.detail;
    if (winner || isDraw) return;     // stop if game over
    if (board[index]) return;         // prevent overwriting moves

    // create new state array to trigger updates
    const newBoard = board.slice();
    newBoard[index] = currentPlayer;
    board = newBoard;

    const { winner: w, line } = checkWinner(board);

    if (w) {
      winner = w;
      winningLine = line;
    } else if (board.every(Boolean)) {
      isDraw = true;
    } else {
      currentPlayer = currentPlayer === 'X' ? 'O' : 'X';
    }
  }

  const statusMessage = () => {
    if (winner) return `${winner} wins!`;
    if (isDraw) return `It's a draw!`;
    return `Player ${currentPlayer}'s turn`;
  };
</script>

<svelte:head>
  <title>Tic Tac Toe</title>
  <meta name="description" content="Play a modern Tic Tac Toe game in your browser." />
</svelte:head>

<section class="wrap">
  <header class="header">
    <h1 class="title">Tic Tac Toe</h1>
    <p class={`status ${winner ? 'status-win' : isDraw ? 'status-draw' : 'status-turn'}`} aria-live="polite">
      {statusMessage()}
    </p>
  </header>

  <div class="surface">
    <Board
      {board}
      {winningLine}
      disabled={Boolean(winner) || isDraw}
      on:move={handleMove}
    />
  </div>

  <footer class="controls">
    <button class="btn primary" onclick={resetGame} aria-label="Start new game">
      New Game
    </button>
    <button class="btn ghost" onclick={resetGame} aria-label="Reset game">
      Reset
    </button>
  </footer>
</section>

<style>
  :global(:root) {
    --primary: #2563EB;
    --secondary: #F59E0B;
    --success: #F59E0B;
    --error: #EF4444;
    --bg: #f9fafb;
    --surface: #ffffff;
    --text: #111827;
  }

  .wrap {
    display: grid;
    gap: 1rem;
    width: min(720px, calc(100vw - 2rem));
    margin: 0 auto;
    padding: 1rem 0 2rem;
  }

  .header {
    text-align: center;
  }

  .title {
    margin: 0 0 0.2rem 0;
    font-size: clamp(1.6rem, 3.4vw, 2rem);
    color: var(--text);
    font-weight: 800;
    letter-spacing: -0.01em;
  }

  .status {
    margin: 0;
    font-size: 1rem;
    color: var(--text);
    opacity: 0.9;
  }

  .status-turn {
    color: var(--primary);
  }

  .status-win {
    color: var(--secondary);
    font-weight: 700;
  }

  .status-draw {
    color: var(--error);
    font-weight: 700;
  }

  .surface {
    margin: 0 auto;
    padding: 16px;
    border-radius: 18px;
    background: linear-gradient(180deg, rgba(37, 99, 235, 0.06), rgba(249, 250, 251, 0.9));
    box-shadow:
      inset 0 1px 0 rgba(255,255,255,0.6),
      0 8px 28px rgba(17, 24, 39, 0.06);
  }

  .controls {
    margin-top: 0.25rem;
    display: flex;
    gap: 0.75rem;
    justify-content: center;
  }

  .btn {
    appearance: none;
    border: 1px solid transparent;
    border-radius: 12px;
    padding: 0.6rem 1rem;
    font-weight: 700;
    letter-spacing: 0.01em;
    cursor: pointer;
    transition: transform 120ms ease, box-shadow 160ms ease, background 160ms ease, border-color 160ms ease, color 160ms ease;
    color: #fff;
    background: var(--primary);
    box-shadow:
      0 1px 1px rgba(255,255,255,0.4) inset,
      0 10px 22px rgba(37, 99, 235, 0.25);
  }

  .btn:hover {
    transform: translateY(-1px);
    box-shadow:
      0 1px 1px rgba(255,255,255,0.5) inset,
      0 16px 30px rgba(37, 99, 235, 0.3);
  }

  .btn:focus-visible {
    outline: 3px solid rgba(37,99,235,0.35);
    outline-offset: 2px;
  }

  .btn.ghost {
    background: #ffffff;
    color: var(--primary);
    border-color: rgba(37,99,235,0.25);
    box-shadow: 0 8px 20px rgba(17, 24, 39, 0.05);
  }

  .btn.ghost:hover {
    background: linear-gradient(180deg, rgba(37,99,235,0.06), #ffffff);
  }
</style>
