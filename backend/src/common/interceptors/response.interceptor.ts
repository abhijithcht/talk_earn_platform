import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { ResponseHelper } from '../helpers/response.helper';

export interface Response<T> {
  success: boolean;
  message: string;
  data?: T;
}

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, Response<T>> {
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<Response<T>> {
    return next.handle().pipe(
      map((res) => {
        // If the service already returns the expected format, don't wrap it again
        if (res && typeof res === 'object' && res.hasOwnProperty('success') && res.hasOwnProperty('message')) {
          return res;
        }

        // Handle specific standard patterns where message is provided
        const message = res?.message || 'Success';
        
        // If it's a message-only response or has other data
        if (res && res.message) {
          const { message, ...data } = res;
          return ResponseHelper.success(
            message,
            Object.keys(data).length > 0 ? data : undefined,
          );
        }

        return ResponseHelper.success('Success', res);
      }),
    );
  }
}
