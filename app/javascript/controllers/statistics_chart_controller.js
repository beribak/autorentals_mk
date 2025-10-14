import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    type: String,
    months: Array,
    data: Array,
    title: String
  }

  connect() {
    // Wait for ApexCharts to load if it's not available yet
    if (typeof ApexCharts !== 'undefined') {
      this.initializeChart()
    } else {
      // Poll for ApexCharts availability
      const checkApexCharts = () => {
        if (typeof ApexCharts !== 'undefined') {
          this.initializeChart()
        } else {
          setTimeout(checkApexCharts, 100)
        }
      }
      checkApexCharts()
    }
  }

  initializeChart() {
    console.log('Initializing chart:', this.typeValue)
    console.log('Months:', this.monthsValue)
    console.log('Data:', this.dataValue)
    
    let chartOptions
    
    if (this.typeValue === "revenue") {
      chartOptions = this.getRevenueChartOptions()
    } else if (this.typeValue === "rentals") {
      chartOptions = this.getRentalsChartOptions()
    }

    if (chartOptions) {
      const chart = new ApexCharts(this.element, chartOptions)
      chart.render()
    }
  }

  getRevenueChartOptions() {
    return {
      series: [{
        name: 'Приход',
        data: this.dataValue
      }],
      chart: {
        type: 'area',
        height: 400,
        toolbar: {
          show: false
        },
        animations: {
          enabled: true,
          easing: 'easeinout',
          speed: 800
        }
      },
      dataLabels: {
        enabled: false
      },
      stroke: {
        curve: 'smooth',
        width: 3
      },
      xaxis: {
        categories: this.monthsValue,
        labels: {
          style: {
            fontSize: '12px',
            fontWeight: 500
          },
          rotate: -45
        }
      },
      yaxis: {
        labels: {
          formatter: function (val) {
            return "€" + val.toLocaleString()
          },
          style: {
            fontSize: '12px',
            fontWeight: 500
          }
        }
      },
      tooltip: {
        y: {
          formatter: function (val) {
            return "€" + val.toLocaleString()
          }
        }
      },
      fill: {
        type: 'gradient',
        gradient: {
          shadeIntensity: 1,
          opacityFrom: 0.7,
          opacityTo: 0.3,
          stops: [0, 90, 100]
        }
      },
      colors: ['#428bca'],
      grid: {
        borderColor: '#f1f1f1',
        strokeDashArray: 4
      }
    }
  }

  getRentalsChartOptions() {
    return {
      series: [{
        name: 'Изнајмени возила',
        data: this.dataValue
      }],
      chart: {
        type: 'bar',
        height: 400,
        toolbar: {
          show: false
        },
        animations: {
          enabled: true,
          easing: 'easeinout',
          speed: 800
        }
      },
      plotOptions: {
        bar: {
          borderRadius: 4,
          horizontal: false,
          columnWidth: '60%'
        }
      },
      dataLabels: {
        enabled: false
      },
      xaxis: {
        categories: this.monthsValue,
        labels: {
          style: {
            fontSize: '12px',
            fontWeight: 500
          },
          rotate: -45
        }
      },
      yaxis: {
        labels: {
          formatter: function (val) {
            return Math.floor(val)
          },
          style: {
            fontSize: '12px',
            fontWeight: 500
          }
        }
      },
      tooltip: {
        y: {
          formatter: function (val) {
            return val + " возила"
          }
        }
      },
      colors: ['#5cb85c'],
      grid: {
        borderColor: '#f1f1f1',
        strokeDashArray: 4
      }
    }
  }
}