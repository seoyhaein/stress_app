package main

import (
	"context"
	"fmt"
	"github.com/spf13/cobra"
	"log"
	"os"
	"os/signal"
	"runtime"
	"syscall"
)

var (
	memMB       int
	cpuRoutines int
	rootCmd     = &cobra.Command{
		Use:   "stress_app",
		Short: "CPU와 메모리를 소모하는 간단한 테스트 앱",
		Run:   runStress,
	}
)

func init() {
	// 전역 플래그 정의
	rootCmd.Flags().IntVar(&memMB, "mem", 100, "메모리 할당량 (MB)")
	rootCmd.Flags().IntVar(&cpuRoutines, "cpu", 1, "CPU 바운드 고루틴 수")
}

func runStress(cmd *cobra.Command, args []string) {
	// 시그널 컨텍스트 설정
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	// 1) 메모리 할당 및 Touch
	buf := make([]byte, memMB*1024*1024)
	for i := range buf {
		buf[i] = 0
	}
	fmt.Printf("Allocated %d MB\n", memMB)

	// 2) CPU 바운드 고루틴 기동
	for i := 0; i < cpuRoutines; i++ {
		go func(id int) {
			for {
				_ = runtime.NumGoroutine()
			}
		}(i)
	}
	fmt.Printf("Spinning %d CPU-bound goroutines\n", cpuRoutines)

	// 3) 시그널 대기 및 graceful shutdown
	<-ctx.Done()
	fmt.Println("Shutdown signal received, cleaning up...")
	// TODO: 필요 시 정리 로직 추가
	fmt.Println("Exiting now.")
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatalf("Command execution failed: %v", err)
	}
}
