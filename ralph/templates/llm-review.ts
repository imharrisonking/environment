// LLM-as-judge fixture for automated reviews
// Supports text and multimodal (image/screenshot) evaluation

export interface ReviewResult {
  passed: boolean;
  score: number;
  feedback: string;
}

export interface ReviewConfig {
  intelligence?: 'fast' | 'smart'; // Default: 'fast'
  criteria?: string[];
}

export interface MultimodalInput {
  text?: string;
  imagePaths?: string[];
}

/**
 * Create a review using LLM-as-judge
 * @param input Text and/or image paths to evaluate
 * @param config Review configuration options
 * @returns Review result with pass/fail and feedback
 */
export async function createReview(
  input: MultimodalInput,
  config?: ReviewConfig
): Promise<ReviewResult> {
  throw new Error('not implemented');
}
