import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ShowCategoryGraphComponent } from './show-category-graph.component';

describe('ShowCategoryGraphComponent', () => {
  let component: ShowCategoryGraphComponent;
  let fixture: ComponentFixture<ShowCategoryGraphComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ShowCategoryGraphComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ShowCategoryGraphComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
