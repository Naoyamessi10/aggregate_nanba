import { Injectable } from '@angular/core';
import { HttpEvent, HttpInterceptor, HttpHandler, HttpRequest } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable()
export class HttpsInterceptor implements HttpInterceptor {
  constructor() {}
  // リクエストの変換処理。ここに共通処理を記述。
  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
    ): Observable<HttpEvent<any>> {
      request = request.clone({
        withCredentials: false
      });
      return next.handle(request);
    }
  }
