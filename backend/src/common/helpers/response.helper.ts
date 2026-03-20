export class ResponseHelper {
  /**
   * Success response wrapper
   * @param message Success message
   * @param data Optional data payload
   */
  static success<T>(message: string, data?: T) {
    return {
      success: true,
      message,
      data: data ?? null,
    };
  }

  /**
   * Error response wrapper
   * @param message Error message
   * @param data Optional error details (e.g. validation errors)
   */
  static error<T>(message: string, data?: T) {
    return {
      success: false,
      message,
      data: data ?? null,
    };
  }
}
