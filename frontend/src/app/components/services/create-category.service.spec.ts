import { TestBed } from '@angular/core/testing';

import { CreateCategoryService } from './create-category.service';

describe('CreateCategoryService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: CreateCategoryService = TestBed.get(CreateCategoryService);
    expect(service).toBeTruthy();
  });
});
