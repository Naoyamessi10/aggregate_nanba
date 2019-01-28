import { Component, ViewChild, ElementRef, Input } from '@angular/core';
import { Chart } from 'chart.js';

import { ShowGraphService } from '../services/show-graph.service';
import { WorkTime } from '../work_time';

@Component({
  selector: 'app-show-graph',
  templateUrl: './show-graph.component.html',
  styleUrls: ['./show-graph.component.css'],
  providers: [ShowGraphService]
})
export class ShowGraphComponent {
  @Input() data = [];
  work_time: WorkTime;
  color_array = ['#ff1493', '#87cefa', '#bdb76b','#d3d3d3', '#808080', '#fffff0', '#afeeee','#c0c0c0', '#696969','#ffe4e1', '#000080','#f0f8ff', '#4169e1', '#add8e6','#ff00ff']

  @ViewChild('myChart') ref: ElementRef;

  context: CanvasRenderingContext2D;
  chart: Chart;

  constructor() {} 

  ngOnInit() {
    this.context = (<HTMLCanvasElement>this.ref.nativeElement).getContext('2d');
    this.context.canvas.height = 300;
    this.draw('pie', this.getworktimes(this.data));
  }

  getworktimes(data){
    var category_name = [];
    var time = [];
    for(var work_time in data) {
      category_name.push(work_time)
      time.push(data[work_time]);
    }
    return [category_name,time]
  }

  draw(show_type,work_time) {
    this.chart = new Chart(this.context, {
      type: show_type,
      data: {
        labels: work_time[0],
        datasets: [{
          label: 'カテゴリ',
          data: work_time[1],
          backgroundColor: this.color_array.slice(0,work_time[1].length)
        }]
      }
    });
  }

}