import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { AppRoutingModule } from './app-routing.module'; 
import { CookieService } from 'ngx-cookie-service';
import { HttpsInterceptor } from './shared/services/http.interceptor';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToastrModule } from 'ngx-toastr';

import { AppComponent } from './app.component';
import { TopMenuComponent } from './components/top-menu.component';
import { ShowGraphComponent } from './components/show-graph/show-graph.component';
import { InputDateComponent } from './components/input-date/input-date.component';
import { CreateCategoryComponent } from './components/create-category/create-category.component';

import { InputDateService } from './components/services/input-date.service';
import { CreateCategoryService } from './components/services/create-category.service';
import { ShowGraphService } from './components/services/show-graph.service';
import { ShowCategoryGraphComponent } from '../app/components/show-category-graph/show-category-graph.component';
import { ShowNormalGraphComponent } from '../app/components/show-normal-graph/show-normal-graph.component';
import { SelectDateComponent } from './shared/components/select-date/select-date.component';

@NgModule({
  declarations: [
    AppComponent,
    ShowGraphComponent,
    TopMenuComponent,
    InputDateComponent,
    CreateCategoryComponent,
    ShowCategoryGraphComponent,
    ShowNormalGraphComponent,
    SelectDateComponent
  ],
  imports: [
    HttpClientModule,
    BrowserModule,
    FormsModule,
    ReactiveFormsModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    ToastrModule.forRoot({
      timeOut: 2000,
      positionClass: 'toast-top-center',
      preventDuplicates: false
    })
  ],
  providers: [
    InputDateService,
    CreateCategoryService,
    ShowGraphService,
    CookieService,
    { provide: HTTP_INTERCEPTORS, useClass: HttpsInterceptor, multi: true },
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
