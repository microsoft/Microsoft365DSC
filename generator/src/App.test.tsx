import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { App } from './App';

describe('App', () => {
  it('renders the generator page', () => {
    render(<App />);
    const generateButton = screen.getByText(/Generate/i);
    expect(generateButton).toBeInTheDocument();
  });
});
