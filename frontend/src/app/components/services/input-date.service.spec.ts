import { TestBed } from '@angular/core/testing';

import { InputDateService } from './input-date.service';

describe('InputDateService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: InputDateService = TestBed.get(InputDateService);
    expect(service).toBeTruthy();
  });
});
