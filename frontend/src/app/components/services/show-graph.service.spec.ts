import { TestBed } from '@angular/core/testing';

import { ShowGraphService } from './show-graph.service';

describe('ShowGraphService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ShowGraphService = TestBed.get(ShowGraphService);
    expect(service).toBeTruthy();
  });
});
