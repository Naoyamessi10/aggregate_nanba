import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ShowNormalGraphComponent } from './show-normal-graph.component';

describe('ShowNormalGraphComponent', () => {
  let component: ShowNormalGraphComponent;
  let fixture: ComponentFixture<ShowNormalGraphComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ShowNormalGraphComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ShowNormalGraphComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
