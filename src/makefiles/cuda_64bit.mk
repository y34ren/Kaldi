ifndef DOUBLE_PRECISION
$(error DOUBLE_PRECISION not defined.)
endif
ifndef CUDATKDIR
$(error CUDATKDIR not defined.)
endif

CXXFLAGS += -DHAVE_CUDA -I$(CUDATKDIR)/include -fPIC -pthread -isystem $(OPENFSTINC)

CUDA_INCLUDE= -I$(CUDATKDIR)/include -I$(CUBROOT)
CUDA_FLAGS = --machine 64 -DHAVE_CUDA \
             -ccbin $(CXX) -DKALDI_DOUBLEPRECISION=$(DOUBLE_PRECISION) \
             -std=c++14 -DCUDA_API_PER_THREAD_DEFAULT_STREAM  -lineinfo \
             --verbose -Wno-deprecated-gpu-targets

ifeq ($(shell test -e $(CUDATKDIR)/lib64/libcudart_static.a && echo -n yes),yes)
CUDA_LDFLAGS += -L$(CUDATKDIR)/lib64 -Wl,-rpath,$(CUDATKDIR)/lib64
else
CUDA_LDFLAGS += -L$(CUDATKDIR)/lib -Wl,-rpath,$(CUDATKDIR)/lib
endif

CUDA_LDLIBS += -lcublas -lcusparse -lcudart -lcurand -lcufft -lnvToolsExt #LDLIBS : The .so libs are loaded later than static libs in implicit rule
