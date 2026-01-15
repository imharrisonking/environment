// LLM Review Test Examples
// Demonstrates usage patterns for LLM-as-judge reviews

describe('LLM Review - Text Evaluation', () => {
  it('should evaluate message tone', async () => {
    const result = await createReview({
      text: 'Your code is terrible and you should feel bad.'
    });
    expect(result.passed).toBe(false);
    expect(result.feedback).toContain('hostile');
  });

  it('should validate message quality', async () => {
    const result = await createReview({
      text: 'Please review this PR when you have time.'
    });
    expect(result.passed).toBe(true);
  });
});

describe('LLM Review - Multimodal/Screenshot Evaluation', () => {
  it('should evaluate UI/UX from screenshot', async () => {
    const result = await createReview({
      imagePaths: ['./screenshots/homepage.png']
    });
    expect(result.feedback).toMatch(/hierarchy|contrast|alignment/i);
  });

  it('should assess visual hierarchy', async () => {
    const result = await createReview({
      text: 'Is the CTA prominent?',
      imagePaths: ['./screenshots/landing.png']
    });
    expect(result.passed).toBe(true);
  });
});

describe('LLM Review - Intelligence Levels', () => {
  it('should use fast intelligence for quick checks', async () => {
    const result = await createReview(
      { text: 'This is a test message.' },
      { intelligence: 'fast' }
    );
    expect(result.passed).toBeDefined();
  });

  it('should use smart intelligence for complex judgment', async () => {
    const result = await createReview(
      {
        text: 'Evaluate this complex UX pattern.',
        imagePaths: ['./screenshots/complex-ui.png']
      },
      { intelligence: 'smart' }
    );
    expect(result.score).toBeGreaterThan(0);
  });
});

describe('LLM Review - Failure Handling', () => {
  it('should display helpful feedback on failure', async () => {
    const result = await createReview({
      text: 'This message fails all quality checks.'
    });
    expect(result.passed).toBe(false);
    expect(result.feedback.length).toBeGreaterThan(10);
  });
});
