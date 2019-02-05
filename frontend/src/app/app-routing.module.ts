import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { InputDateComponent } from './components/input-date/input-date.component';
import { ShowGraphComponent } from './components/show-graph/show-graph.component';
import { ShowCategoryGraphComponent } from './components/show-category-graph/show-category-graph.component';
import { ShowNormalGraphComponent } from './components/show-normal-graph/show-normal-graph.component';
import { TopMenuComponent } from './components/top-menu.component';

NgModule({
  imports: [
    CommonModule
  ],
  declarations: []
})

const routes: Routes = [
  { path: '', component: InputDateComponent },
  { path: 'callback', component: InputDateComponent },
  { path: 'show', component: ShowGraphComponent },
  { path: 'category-graph', component:ShowCategoryGraphComponent },
  { path: 'normal-graph', component: ShowNormalGraphComponent },
  { path: 'top', component: TopMenuComponent }
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: []
})
export class AppRoutingModule { }

